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
    @ObservedObject var activeRoute: ActiveRoute

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

            if activeRoute.exists {
                selectAnnotation(for: activeRoute.currentLocation, with: uiView)
            }
        }

        if !stayAtLocation {
            uiView.userTrackingMode = trackingMode
        }

        if let activeVisitLocation = activeVisitLocation {
            selectAnnotation(for: activeVisitLocation, with: uiView)
        }
    }

    private func selectAnnotation(for location: Location, with map: MGLMapView) {
        let activeAnnotation = LocationAnnotation(location: location)
        map.setCenter(location.coordinate, zoomLevel: 15, animated: true)
        map.selectAnnotation(activeAnnotation, animated: true, completionHandler: { })
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, MGLMapViewDelegate {
        var parent: MapView

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
        MapView(mapState: .constant(.showingMap), trackingMode: .constant(.follow), showingToggleButton: .constant(true), stayAtLocation: .constant(false), activeVisitLocation: .constant(nil), activeRoute: .init(), userLocationColor: .red, annotations: [])
    }
}
