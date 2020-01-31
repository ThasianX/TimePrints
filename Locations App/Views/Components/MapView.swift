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
//    @ObservedObject var locationManager = LocationManager()
    @Binding var isFollowingUser: Bool
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let map = MKMapView(frame: UIScreen.main.bounds)
        map.delegate = context.coordinator
        map.showsUserLocation = true
        map.setUserTrackingMode(.followWithHeading, animated: true)
        return map
    }
    
    func updateUIView(_ map: MKMapView, context: UIViewRepresentableContext<MapView>) {
        self.centerOnLocation(map.userLocation.coordinate, map: map)
            
        self.updateAnnotations(from: map)
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
    
    private func centerOnLocation(_ coordinate: CLLocationCoordinate2D, map: MKMapView) {
        map.setCenter(coordinate: coordinate, zoomLevel: 15, animated: true)
    }
    
    private func updateAnnotations(from mapView: MKMapView) {
        print("a")
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(isFollowingUser: .constant(true))
    }
}

