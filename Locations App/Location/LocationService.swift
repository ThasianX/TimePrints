// Kevin Li - 10:44 PM - 2/29/20

import CoreLocation
import Foundation

protocol LocationService {
    func startTrackingVisits()
    func distanceFromCurrentLocation(location: Location) -> String
}

class MockLocationService: LocationService {
    func startTrackingVisits() {}
    func distanceFromCurrentLocation(location: Location) -> String {
        return "5 mi"
    }
}
