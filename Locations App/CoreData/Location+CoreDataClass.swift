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
    // MARK: - Class Functions
    private class func newLocation() -> Location {
        Location(context: CoreData.stack.context)
    }
    
    @discardableResult
    class func create(visit: CLVisit, place: CLPlacemark) -> Location {
        let details = ReversedGeoLocation(with: place)
        let newVisit = Visit.create(arrivalDate: visit.arrivalDate, departureDate: visit.departureDate)
        var location = Location.location(for: details.address)
        if location != nil {
            location!.addVisit(newVisit)
        } else {
            location = create(visit.coordinate, visit: newVisit, details: details)
        }
        return location!
    }
    
    class func location(for address: String) -> Location? {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%@ == address", address)
        
        let location = try! CoreData.stack.context.fetch(fetchRequest)
        return location.first
    }
    
    class func create(_ coordinates: CLLocationCoordinate2D, visit: Visit, details: ReversedGeoLocation) -> Location {
        let location = newLocation()
        location.latitude = coordinates.latitude
        location.longitude = coordinates.longitude
        location.name = details.name
        location.address = details.address
        location.tag = Tag.getDefault()
        location.addVisit(visit)
        
        CoreData.stack.save()
        
        return location
    }
    
    // MARK: - Local Functions
    func setTag(tag: Tag) {
        self.tag = tag
        CoreData.stack.save()
    }
    
    func delete() -> Location {
        let location = self
        CoreData.stack.context.delete(self)
        return location
    }
    
    // MARK: - Computed Properties
    var accent: UIColor {
        UIColor(self.tag.color)
    }
    
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: self.latitude, longitude: self.longitude)
    }
}
