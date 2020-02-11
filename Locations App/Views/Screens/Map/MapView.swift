//
//  MapView.swift
//  Locations App
//
//  Created by Kevin Li on 1/29/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI
import Mapbox

struct MapView: UIViewRepresentable {
    @Binding var trackingMode: MGLUserTrackingMode
    @Binding var selectedLocation: Location?
    @Binding var showingEditTag: Bool
    @Binding var showingLocationVisits: Bool
    @Binding var stayAtLocation: Bool
    
    let annotations: [LocationAnnotation]
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MGLMapView {
        let styleURL = URL(string: "mapbox://styles/mapbox/navigation-preview-night-v4")!
        let mapView = MGLMapView(frame: .zero, styleURL: styleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = context.coordinator
        mapView.tintColor = .red
        mapView.attributionButton.tintColor = .lightGray
        mapView.showsUserLocation = true
        mapView.showsUserHeadingIndicator = true
        return mapView
    }
    
    func updateUIView(_ map: MGLMapView, context: UIViewRepresentableContext<MapView>) {
        map.addAnnotations(annotations)
        if !stayAtLocation {
            map.userTrackingMode = trackingMode
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
            
            let identifier = "visit"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = CustomAnnotationView(reuseIdentifier: identifier)
                annotationView!.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
                annotationView!.backgroundColor = annotation.color
            }
            
            return annotationView
        }
        
        func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
            guard let annotation = annotation as? LocationAnnotation else { return nil }
            let button = UIButton(frame: .init(x: 0, y: 0, width: 30, height: 30))
            let tag = UIImage(named: "tag.fill")!.withRenderingMode(.alwaysTemplate).withTintColor(annotation.location.accent)
            button.setImage(tag, for: .normal)
            button.tag = 0
            return button
        }
        
        func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
            let button = UIButton(frame: .init(x: 0, y: 0, width: 30, height: 30))
            let tag = UIImage(named: "info.circle.fill")!.withRenderingMode(.alwaysTemplate).withTintColor(.blue)
            button.setImage(tag, for: .normal)
            button.tag = 1
            return button
        }
        
        func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
            guard let annotation = annotation as? LocationAnnotation else { return }
            mapView.deselectAnnotation(annotation, animated: true)
            
            switch control.tag {
            case 0:
                parent.selectedLocation = annotation.location
                parent.showingEditTag = true
                parent.stayAtLocation = true
            case 1:
                parent.selectedLocation = annotation.location
                parent.showingLocationVisits = true
                parent.stayAtLocation = true
            default:
                ()
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(trackingMode: .constant(.follow), selectedLocation: .constant(nil), showingEditTag: .constant(false), showingLocationVisits: .constant(false), stayAtLocation: .constant(false), annotations: [])
    }
}
