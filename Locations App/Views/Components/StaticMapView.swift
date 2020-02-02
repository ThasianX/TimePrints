//
//  StaticMapView.swift
//  Locations App
//
//  Created by Kevin Li on 2/2/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI
import MapKit

struct StaticMapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    let coordinate: CLLocationCoordinate2D
    
    func makeUIView(context: UIViewRepresentableContext<StaticMapView>) -> MKMapView {
        let map = MKMapView(frame: .zero)
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<StaticMapView>) {
        uiView.setCenter(coordinate: self.coordinate, zoomLevel: 20, animated: false)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        uiView.addAnnotation(annotation)
    }
}

struct StaticMapView_Previews: PreviewProvider {
    static var previews: some View {
        StaticMapView(coordinate: .init(latitude: 12.9716, longitude: 77.5946))
    }
}
