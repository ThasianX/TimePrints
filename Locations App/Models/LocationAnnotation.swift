//
//  LocationAnnotation.swift
//  Locations App
//
//  Created by Kevin Li on 2/3/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import Foundation
import Mapbox

final class LocationAnnotation: NSObject, MGLAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var color: UIColor
    
    init(color: UIColor, location: Visit, count: Int) {
        self.coordinate = location.coordinate
        self.title = location.name
        self.subtitle = "Visited \(count) times"
        self.color = color
    }
}
