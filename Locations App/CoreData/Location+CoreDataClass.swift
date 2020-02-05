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
    
    @discardableResult
    class func create(visit: CLVisit, place: CLPlacemark) -> Location {
        let details = ReversedGeoLocation(with: place)
        let newVisit = Visit.create(arrivalDate: visit.arrivalDate, departureDate: visit.departureDate)
        var location = Location.location(for: details.address)
        if location != nil {
            location!.addVisit(newVisit)
        } else {
            location = create(visit.coordinate, visit: newVisit, name: details.name, address: details.address)
        }
        return location!
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

extension Location {
    // MARK: - Preview
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
    
    class func deleteAll() {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Location.fetchRequest())
        try! CoreData.stack.context.execute(batchDeleteRequest)
    }
}
