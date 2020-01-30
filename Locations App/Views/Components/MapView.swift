//
//  MapView.swift
//  Locations App
//
//  Created by Kevin Li on 1/29/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let map = MKMapView(frame: UIScreen.main.bounds)
        map.delegate = context.coordinator
        map.showsUserLocation = true
        map.userTrackingMode = .follow
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        updateAnnotations(from: uiView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }


    }
    
    private func updateAnnotations(from mapView: MKMapView) {
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
