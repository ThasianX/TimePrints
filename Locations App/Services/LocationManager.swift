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

class LocationManager: NSObject {//, ObservableObject {
//    @Published var currentLocation: CLLocation? {
//        willSet { objectWillChange.send() }
//    }
    
    private let locationManager = CLLocationManager()
    private let geoCoder: CLGeocoder = CLGeocoder()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringVisits()
        locationManager.startUpdatingLocation()
    }
    
//    func startFollowingUser() {
//        locationManager.startUpdatingLocation()
//    }
//
//    func stopFollowingUser() {
//        locationManager.stopUpdatingLocation()
//    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        if visit.departureDate != Date.distantFuture {
            let clLocation = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
            
            geoCoder.reverseGeocodeLocation(clLocation) { placeMarks, error in
                if let place = placeMarks?.first {
                    self.newVisitReceived(visit, place: place)
                }
            }
        }
    }
    
    private func newVisitReceived(_ visit: CLVisit, place: CLPlacemark) {
        Visit.create(visit: visit, place: place)
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            currentLocation = location
//        }
//    }
}
