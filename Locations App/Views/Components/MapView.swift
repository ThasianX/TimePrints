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
    @Binding var selectedLocation: Visit?
    @Binding var showingEditTag: Bool
    let annotations: [MGLPointAnnotation]
    let annotationsToLocations: [String : Visit]
    
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
        map.userTrackingMode = trackingMode
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, MGLMapViewDelegate {
        var parent: MapView
        let star = UIImage(named: "star")!.withRenderingMode(.alwaysTemplate).withTintColor(.yellow)
        let starFill = UIImage(named: "star.fill")!.withRenderingMode(.alwaysTemplate).withTintColor(.yellow)

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            true
        }
        
        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            guard annotation is MGLPointAnnotation else { return nil }
            
            let identifier = "visit"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            let location = parent.annotationsToLocations[annotation.title!!]!
            
            if annotationView == nil {
                annotationView = CustomAnnotationView(reuseIdentifier: identifier)
                annotationView!.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
                annotationView!.backgroundColor = location.accent
            }
            
            return annotationView
        }
        
        func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
            let location = parent.annotationsToLocations[annotation.title!!]!
            let button = UIButton(frame: .init(x: 0, y: 0, width: 30, height: 30))
            if location.isFavorite {
                button.setImage(starFill, for: .normal)
            } else {
                button.setImage(star, for: .normal)
            }
            return button
        }
    
        func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
            
        }
        
        func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
            if let button = control as? UIButton {
                let location = parent.annotationsToLocations[annotation.title!!]!
                location.favorite()
                if location.isFavorite {
                    button.setImage(starFill, for: .normal)
                } else {
                    button.setImage(star, for: .normal)
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(trackingMode: .constant(.follow), annotations: [Visit.preview.asAnnotation], annotationsToLocations: [Visit.preview.name : Visit.preview])
    }
}
