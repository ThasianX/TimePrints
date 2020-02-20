import SwiftUI
import Mapbox

struct MapView: UIViewRepresentable {
    @Binding var trackingMode: MGLUserTrackingMode
    @Binding var selectedLocation: Location?
    @Binding var showingEditTag: Bool
    @Binding var showingLocationVisits: Bool
    @Binding var stayAtLocation: Bool
    @Binding var activeVisitLocation: Location?
    
    let annotations: [LocationAnnotation]
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MGLMapView {
        return MGLMapView.makeDefault(with: context.coordinator, tintColor: .red)
    }
    
    func updateUIView(_ map: MGLMapView, context: UIViewRepresentableContext<MapView>) {
        map.addAnnotations(annotations)
        if !stayAtLocation {
            map.userTrackingMode = trackingMode
        }
        if activeVisitLocation != nil {
            let annotation = LocationAnnotation.init(location: activeVisitLocation!)
            map.setCenter(activeVisitLocation!.coordinate, zoomLevel: 13, animated: true)
            map.selectAnnotation(annotation, animated: true, completionHandler: { })
            DispatchQueue.main.async {
                self.activeVisitLocation = nil
            }
        }
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
                setLocationWithoutRecentering(location: annotation.location)
                parent.showingEditTag = true
            case 1:
                setLocationWithoutRecentering(location: annotation.location)
                parent.showingLocationVisits = true
            default:
                ()
            }
        }

        private func setLocationWithoutRecentering(location: Location) {
            parent.selectedLocation = location
            parent.stayAtLocation = true
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
        MapView(trackingMode: .constant(.follow), selectedLocation: .constant(nil), showingEditTag: .constant(false), showingLocationVisits: .constant(false), stayAtLocation: .constant(false), activeVisitLocation: .constant(nil), annotations: [])
    }
}
