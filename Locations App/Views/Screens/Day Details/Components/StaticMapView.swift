//
//  StaticMapView.swift
//  Locations App
//
//  Created by Kevin Li on 2/2/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI
import Mapbox

struct StaticMapView: UIViewRepresentable {
    let coordinate: CLLocationCoordinate2D
    let name: String
    let color: UIColor
    
    func makeUIView(context: UIViewRepresentableContext<StaticMapView>) -> MGLMapView {
        let styleURL = URL(string: "mapbox://styles/mapbox/navigation-preview-night-v4")!
        let mapView = MGLMapView(frame: .zero, styleURL: styleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = context.coordinator
        mapView.tintColor = .red
        mapView.attributionButton.tintColor = .lightGray
        mapView.showsUserLocation = true
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
            
            let annotationView = CustomAnnotationView()
            annotationView.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
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
