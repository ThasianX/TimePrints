//
//  LocationManager.swift
//  Locations App
//
//  Created by Kevin Li on 1/28/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI
import Foundation
import CoreLocation
import Combine
import CoreData

class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    private let geoCoder: CLGeocoder = CLGeocoder()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringVisits()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        let clLocation = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(clLocation) { placeMarks, error in
            if let place = placeMarks?.first {
                self.newVisitReceived(visit, place: place)
            }
        }
    }
    
    private func newVisitReceived(_ visit: CLVisit, place: CLPlacemark) {
        Location.create(visit: visit, place: place)
    }
}
