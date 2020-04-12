import Foundation
import CoreData
import Mapbox

@objc(Location)
public class Location: NSManagedObject {
    class func count() -> Int {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()

        do {
            let count = try CoreData.stack.context.count(for: fetchRequest)
            return count
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }

    private class func newLocation() -> Location {
        Location(context: CoreData.stack.context)
    }

    class func location(for address: String) -> Location? {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%@ == address", address)

        let location = try! CoreData.stack.context.fetch(fetchRequest)
        return location.first
    }

    class func create(_ coordinates: CLLocationCoordinate2D, visit: Visit, name: String, address: String) -> Location {
        let location = newLocation()
        location.latitude = coordinates.latitude
        location.longitude = coordinates.longitude
        location.name = name
        location.address = address
        location.tag = Tag.default
        location.addVisit(visit)

        CoreData.stack.save()

        return location
    }
}

extension Location {
    class func beginVisit(with visit: CLVisit, placeDetails: ReversedGeoLocation) {
        let location = self.location(for: placeDetails.address)
        let locationExistsInDatabase = location != nil

        if locationExistsInDatabase {
            location!.addIncompleteVisit(with: visit)
        } else {
            Location.create(incompleteVisit: visit, placeDetails: placeDetails)
        }
    }

    private func addIncompleteVisit(with visit: CLVisit) {
        let visit = Visit.create(arrivalDate: visit.arrivalDate)
        addVisit(visit)
        CoreData.stack.save()
    }

    @discardableResult
    class func create(incompleteVisit: CLVisit, placeDetails: ReversedGeoLocation) -> Location {
        let visit = Visit.create(arrivalDate: incompleteVisit.arrivalDate)
        return create(incompleteVisit.coordinate, visit: visit, name: placeDetails.name, address: placeDetails.address)
    }

    class func completeVisit(with visit: CLVisit, placeDetails: ReversedGeoLocation) {
        let incompleteVisit = Visit.fetch(with: visit.arrivalDate)
        let incompleteVisitExistsInDatabase = incompleteVisit != nil

        if incompleteVisitExistsInDatabase {
            incompleteVisit!.complete(with: visit.departureDate)
        } else {
            addCompletedVisit(with: visit, placeDetails: placeDetails)
        }
    }

    private class func addCompletedVisit(with visit: CLVisit, placeDetails: ReversedGeoLocation) {
        let location = Location.location(for: placeDetails.address)
        let locationExistsInDatabase = location != nil

        if locationExistsInDatabase {
            location!.addCompletedVisit(with: visit)
        } else {
            Location.create(completeVisit: visit, placeDetails: placeDetails)
        }
    }

    private func addCompletedVisit(with visit: CLVisit) {
        let completedVisit = Visit.create(arrivalDate: visit.arrivalDate, departureDate: visit.departureDate)
        addVisit(completedVisit)
        CoreData.stack.save()
    }

    @discardableResult
    class func create(completeVisit: CLVisit, placeDetails: ReversedGeoLocation) -> Location {
        let visit = Visit.create(arrivalDate: completeVisit.arrivalDate, departureDate: completeVisit.departureDate)
        return create(completeVisit.coordinate, visit: visit, name: placeDetails.name, address: placeDetails.address)
    }
}

extension Location {
    func setName(_ name: String) {
        self.name = name
        CoreData.stack.save()
    }

    func setTag(tag: Tag) {
        self.tag = tag
        CoreData.stack.save()
    }

    func delete() -> Location {
        let location = self
        CoreData.stack.context.delete(self)
        return location
    }
}

extension Location {
    var accent: UIColor {
        UIColor(self.tag.color)
    }

    var coordinate: CLLocationCoordinate2D {
        .init(latitude: self.latitude, longitude: self.longitude)
    }
}

extension Location {
    class var preview: Location {
        let location = newLocation()
        location.latitude = 37.33182
        location.longitude = -122.03118
        location.name = "Apple INC"
        location.address = "One Infinite Loop Cupertino, CA 95014"
        let tag = Tag.newTag()
        tag.name = "Visits"
        tag.color = UIColor.berryRed.hexString()
        let visit = Visit.newVisit()
        visit.arrivalDate = Date()
        visit.departureDate = Date().addingTimeInterval(400)
        location.addVisit(visit)
        return location
    }
}
