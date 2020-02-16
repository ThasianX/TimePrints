//
//  Location+CoreDataClass.swift
//  Locations App
//
//  Created by Kevin Li on 2/3/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit

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

    @discardableResult
    class func create(incompleteVisit: CLVisit, placeDetails: ReversedGeoLocation) -> Location {
        let visit = Visit.create(arrivalDate: incompleteVisit.arrivalDate)
        return create(incompleteVisit.coordinate, visit: visit, name: placeDetails.name, address: placeDetails.address)
    }

    @discardableResult
    class func create(completeVisit: CLVisit, placeDetails: ReversedGeoLocation) -> Location {
        let visit = Visit.create(arrivalDate: completeVisit.arrivalDate, departureDate: completeVisit.departureDate)
        return create(completeVisit.coordinate, visit: visit, name: placeDetails.name, address: placeDetails.address)
    }
    
    class func create(_ coordinates: CLLocationCoordinate2D, visit: Visit, name: String, address: String) -> Location {
        let location = newLocation()
        location.latitude = coordinates.latitude
        location.longitude = coordinates.longitude
        location.name = name
        location.address = address
        location.tag = Tag.getDefault()
        location.addVisit(visit)
        
        CoreData.stack.save()
        
        return location
    }
}

extension Location {
    class func beginVisit(with visit: CLVisit, placeDetails: ReversedGeoLocation) {
        let location = self.location(for: placeDetails.address)
        let locationExists = location != nil

        if locationExists {
            location!.beginVisit(for: visit)
        } else {
            Location.create(incompleteVisit: visit, placeDetails: placeDetails)
        }
    }

    class func completeVisit(for visit: CLVisit, placeDetails: ReversedGeoLocation) {
        let incompleteVisit = Visit.visit(with: visit.arrivalDate)
        let incompleteVisitExists = incompleteVisit != nil

        if incompleteVisitExists {
            incompleteVisit!.complete(with: visit.departureDate)
        } else {
            addCompletedVisit(with: visit, placeDetails: placeDetails)
        }
    }

    private class func addCompletedVisit(with visit: CLVisit, placeDetails: ReversedGeoLocation) {
        let location = Location.location(for: placeDetails.address)
        let locationExists = location != nil

        if locationExists {
            location!.addCompletedVisit(with: visit)
        } else {
            Location.create(completeVisit: visit, placeDetails: placeDetails)
        }
    }
}

extension Location {
    func beginVisit(for visit: CLVisit) {
        let visit = Visit.create(arrivalDate: visit.arrivalDate)
        addVisit(visit)
    }

    func addCompletedVisit(with visit: CLVisit) {
        let completedVisit = Visit.create(arrivalDate: visit.arrivalDate, departureDate: visit.departureDate)
        addVisit(completedVisit)
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
