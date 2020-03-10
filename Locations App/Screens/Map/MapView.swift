import SwiftUI
import Mapbox

private extension MapView {
    enum AccessoryType {
        case tag
        case visits
    }
}

struct MapView: UIViewRepresentable {
    @Binding var mapState: MapState
    @Binding var trackingMode: MGLUserTrackingMode
    @Binding var showingToggleButton: Bool
    @Binding var stayAtLocation: Bool
    @Binding var activeVisitLocation: Location?
    @Binding var activeRouteCoordinates: [CLLocationCoordinate2D]

    let userLocationColor: UIColor
    let annotations: [LocationAnnotation]

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MGLMapView {
        MGLMapView.makeDefault(with: context.coordinator, tintColor: userLocationColor)
    }
    
    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<MapView>) {
        if mapState.isShowingMap {
            if let currentAnnotations = uiView.annotations {
                uiView.removeAnnotations(currentAnnotations)
            }
            uiView.addAnnotations(annotations)

            if !activeRouteCoordinates.isEmpty {
                context.coordinator.addAnimatedRoute(mapView: uiView)
            } else {
                context.coordinator.removeAnimatedRoute(mapView: uiView)
            }
        }

        if !stayAtLocation {
            uiView.userTrackingMode = trackingMode
        }

        if let activeVisitLocation = activeVisitLocation {
            let annotation = LocationAnnotation(location: activeVisitLocation)
            uiView.setCenter(activeVisitLocation.coordinate, zoomLevel: 16, animated: true)
            uiView.selectAnnotation(annotation, animated: true, completionHandler: { })
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, MGLMapViewDelegate {
        private let lineIdentifier = "polyline"
        var parent: MapView
        var timer: Timer?
        var polylineSource: MGLShapeSource?
        var currentRouteIndex = 1

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            true
        }
        
        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            guard let annotation = annotation as? LocationAnnotation else { return nil }
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "visit")
            if annotationView == nil {
                annotationView = CustomAnnotationView.makeDefault(identifier: "visit")
            }
            annotationView!.backgroundColor = annotation.color
            
            return annotationView
        }
        
        func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
            guard let annotation = annotation as? LocationAnnotation else { return nil }
            return UIButton.calloutButton(with: UIImage.tagFill, tintColor: annotation.color, tag: 0)
        }
        
        func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
            UIButton.calloutButton(with: UIImage.infoCircleFill, tintColor: .blue, tag: 1)
        }
        
        func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
            guard let annotation = annotation as? LocationAnnotation else { return }
            mapView.deselectAnnotation(annotation, animated: true)
            
            switch control.tag {
            case 0:
                setLocationWithoutRecentering(for: .tag, location: annotation.location)
            case 1:
                setLocationWithoutRecentering(for: .visits, location: annotation.location)
            default:
                ()
            }
        }

        private func setLocationWithoutRecentering(for accessoryType: AccessoryType, location: Location) {
            setLocation(for: accessoryType, location: location)
            preventRecentering()
            hideToggleButton()
        }

        private func setLocation(for accessoryType: AccessoryType, location: Location) {
            switch accessoryType {
            case .tag:
                parent.mapState = .showingEditTag(location)
            case .visits:
                parent.mapState = .showingLocationVisits(location)
            }
        }

        private func preventRecentering() {
            parent.stayAtLocation = true
            parent.activeVisitLocation = nil
        }

        private func hideToggleButton() {
            parent.showingToggleButton = false
        }

        func addAnimatedRoute(mapView: MGLMapView) {
            guard let mapStyle = mapView.style else { return }

            addPolyline(to: mapStyle)
            animatePolyline()
        }

        private func addPolyline(to style: MGLStyle) {
            // Add an empty MGLShapeSource, we’ll keep a reference to this and add points to this later.
            let source = MGLShapeSource(identifier: lineIdentifier, shape: nil, options: nil)
            style.addSource(source)
            polylineSource = source

            // Add a layer to style our polyline.
            let layer = MGLLineStyleLayer(identifier: lineIdentifier, source: source)
            layer.lineJoin = NSExpression(forConstantValue: "round")
            layer.lineCap = NSExpression(forConstantValue: "round")
            layer.lineColor = NSExpression(forConstantValue: UIColor.red)

            // The line width should gradually increase based on the zoom level.
            layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                           [14: 5, 18: 20])
            style.addLayer(layer)
        }

        private func animatePolyline() {
            currentRouteIndex = 1

            // Start a timer that will simulate adding points to our polyline. This could also represent coordinates being added to our polyline from another source, such as a CLLocationManagerDelegate.
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        }

        @objc private func tick() {
            if currentRouteIndex > parent.activeRouteCoordinates.count {
                timer?.invalidate()
                timer = nil
                return
            }

            // Create a subarray of locations up to the current index.
            let coordinates = Array(parent.activeRouteCoordinates[0..<currentRouteIndex])

            // Update our MGLShapeSource with the current locations.
            updatePolylineWithCoordinates(coordinates: coordinates)

            currentRouteIndex += 1
        }

        private func updatePolylineWithCoordinates(coordinates: [CLLocationCoordinate2D]) {
            var mutableCoordinates = coordinates

            let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))

            // Updating the MGLShapeSource’s shape will have the map redraw our polyline with the current coordinates.
            polylineSource?.shape = polyline
        }

        func removeAnimatedRoute(mapView: MGLMapView) {
            guard let currentLayers = mapView.style?.layers else { return }

            if currentLayers.filter({$0.identifier == lineIdentifier}).first != nil {
                guard let mapStyle = mapView.style else { return }

                if let styleLayer = mapStyle.layer(withIdentifier: lineIdentifier)  {
                    mapStyle.removeLayer(styleLayer)
                }

                if let source = mapStyle.source(withIdentifier: lineIdentifier) {
                    mapStyle.removeSource(source)
                }
            }
        }
    }
}

private extension UIButton {
    static func calloutButton(with image: UIImage, tintColor: UIColor, tag: Int) -> UIButton {
        let button = UIButton(frame: .init(x: 0, y: 0, width: 30, height: 30))
        let calloutImage = image.withRenderingMode(.alwaysTemplate)
        button.setImage(calloutImage, for: .normal)
        button.tintColor = tintColor
        button.tag = tag
        return button
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(mapState: .constant(.showingMap), trackingMode: .constant(.follow), showingToggleButton: .constant(true), stayAtLocation: .constant(false), activeVisitLocation: .constant(nil), activeRouteCoordinates: .constant([]), userLocationColor: .red, annotations: [])
    }
}
