import CoreLocation
import Foundation

class CoreLocationService: NSObject, LocationService {

    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()

    static let shared = CoreLocationService()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }

    private var currentLocation: CLLocation {
        locationManager.location!
    }

    func startTrackingVisits() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringVisits()
    }

    func distanceFromCurrentLocation(location: Location) -> String {
        let targetLocation = location.clLocation
        let distanceInMeters = Measurement(value: currentLocation.distance(from: targetLocation), unit: UnitLength.meters)
        let distanceInMiles = distanceInMeters.converted(to: .miles).value
        return "\(String(format: "%.1f", distanceInMiles)) mi"
    }
}

extension CoreLocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        let location = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
        let visitIsComplete = visit.departureDate != Date.distantFuture

        if !visitIsComplete {
            beginVisit(for: location, visit: visit)
        } else {
            completeVisit(for: location, visit: visit)
        }
    }

    private func beginVisit(for location: CLLocation, visit: CLVisit) {
        getPlacemark(for: location) { place in
            if let place = place {
                self.newVisitReceived(visit, place: place)
            }
        }
    }

    private func newVisitReceived(_ visit: CLVisit, place: CLPlacemark) {
        let placeDetails = ReversedGeoLocation(with: place)
        Location.beginVisit(with: visit, placeDetails: placeDetails)
    }

    private func completeVisit(for location: CLLocation, visit: CLVisit) {
        getPlacemark(for: location) { place in
            if let place = place {
                self.completeVisitReceived(visit, place: place)
            }
        }
    }

    private func completeVisitReceived(_ visit: CLVisit, place: CLPlacemark) {
        let placeDetails = ReversedGeoLocation(with: place)
        Location.completeVisit(with: visit, placeDetails: placeDetails)
    }

    private func getPlacemark(for clLocation: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void) {
        geoCoder.reverseGeocodeLocation(clLocation) { placeMarks, error in
            completionHandler(placeMarks?.first)
        }
    }
}
