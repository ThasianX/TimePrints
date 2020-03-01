import SwiftUI
import Mapbox

struct StaticMapView: UIViewRepresentable {
    let coordinate: CLLocationCoordinate2D
    let name: String
    let color: UIColor
    
    func makeUIView(context: UIViewRepresentableContext<StaticMapView>) -> MGLMapView {
        let mapView = MGLMapView.makeDefault(with: context.coordinator, tintColor: .red)
        mapView.setCenter(coordinate, zoomLevel: 13, animated: false)
        return mapView
    }
    
    
    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<StaticMapView>) {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        uiView.addAnnotation(annotation)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, MGLMapViewDelegate {
        var parent: StaticMapView

        init(_ parent: StaticMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            guard annotation is MGLPointAnnotation else { return nil }

            let annotationView = CustomAnnotationView.makeDefault()
            annotationView.backgroundColor = parent.color
            return annotationView
        }
    }
}

struct StaticMapView_Previews: PreviewProvider {
    static var previews: some View {
        StaticMapView(coordinate: .init(latitude: 12.9716, longitude: 77.5946), name: "Tesla Headquarters", color: .salmon)
    }
}
