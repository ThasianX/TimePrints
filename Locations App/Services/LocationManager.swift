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

class LocationManager: NSObject, ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()

    private let locationManager = CLLocationManager()
    private let geoCoder: CLGeocoder = CLGeocoder()
    
    override init() {
        let calendar = Calendar.current
        let date = Date()
        let dateFrom = calendar.startOfDay(for: date)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: date)!
        let fromPredicate = NSPredicate(format: "%@ >= %@", date as NSDate, dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "%@ <= %@", date as NSDate, dateTo as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        let fetchRequest = NSFetchRequest<Location>(entityName: "Location")
        fetchRequest.predicate = datePredicate
        do {
            self.todayLocations = try CoreData.stack.context.fetch(fetchRequest)
        } catch {
            print("Cannot fetch locations")
            self.todayLocations = []
        }
        super.init()
        self.locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringVisits()
        locationManager.delegate = self
    }

    @Published var todayLocations: [Location] {
        willSet {
            objectWillChange.send()
        }
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
        let location = Location.create(visit: visit, place: place)
        todayLocations.append(location)
    }
}
