//
//  Location+CoreDataClass.swift
//  Locations App
//
//  Created by Kevin Li on 1/28/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(Location)
public class Location: NSManagedObject {
    // MARK: CRUD
    private class func newLocation() -> Location {
        Location(context: CoreData.stack.context)
    }
    
    class func create(_ coordinates: CLLocationCoordinate2D, arrivalDate: Date, departureDate: Date, place: CLPlacemark) -> Location {
        let location = newLocation()
        location.latitude = coordinates.latitude
        location.longitude = coordinates.longitude
        location.arrivalDate = arrivalDate
        location.departureDate = departureDate
        let reversedGeoLocation = ReversedGeoLocation(with: place)
        location.address = reversedGeoLocation.address
        location.name = reversedGeoLocation.name
        CoreData.stack.save()
        
        return location
    }
    
    class func create(visit: CLVisit, place: CLPlacemark) -> Location {
        create(visit.coordinate, arrivalDate: visit.arrivalDate, departureDate: visit.departureDate, place: place)
    }
    
    func addNotes(_ notes: String) {
        self.notes = notes
        CoreData.stack.save()
    }
    
    func favorite() {
        self.favorited.toggle()
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
