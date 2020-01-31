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
import SwiftUI

@objc(Location)
public class Location: NSManagedObject {
    class var preview: Location {
        let location = newLocation()
        location.latitude = 37.3230
        location.longitude = 122.0322
        location.arrivalDate = Date.random(range: 1000)
        location.departureDate = Date().addingTimeInterval(.random(in: 100...2000))
        location.address = "1 Infinite Loop, Cupertino, California"
        location.notes = "Had a great time visiting my friend, who works here. The food is amazing and the pay seems great."
        location.name = "Apple INC"
        location.isFavorite = true
        location.tag = Tag.create(name: "Locations", color: Color("charcoal"))
        CoreData.stack.save()
        return location
    }
    
    class var previewLocations: [Location] {
        var locations = [Location]()
        for _ in 0..<10 {
            let date = Date.random(range: 100)
            for _ in 0..<10 {
                let location = preview
                location.arrivalDate = date
                locations.append(location)
            }
        }
        return locations
    }
    
    // MARK: CRUD
    private class func newLocation() -> Location {
        Location(context: CoreData.stack.context)
    }
    
    private class func create(_ coordinates: CLLocationCoordinate2D, arrivalDate: Date, departureDate: Date, place: CLPlacemark) -> Location {
        let location = newLocation()
        location.latitude = coordinates.latitude
        location.longitude = coordinates.longitude
        location.arrivalDate = arrivalDate
        location.departureDate = departureDate
        let reversedGeoLocation = ReversedGeoLocation(with: place)
        location.address = reversedGeoLocation.address
        location.name = reversedGeoLocation.name
        location.tag = Tag.getDefault()
        CoreData.stack.save()
        
        return location
    }
    
    @discardableResult
    class func create(visit: CLVisit, place: CLPlacemark) -> Location {
        create(visit.coordinate, arrivalDate: visit.arrivalDate, departureDate: visit.departureDate, place: place)
    }
    
    func addNotes(_ notes: String) {
        self.notes = notes
        CoreData.stack.save()
    }
    
    func favorite() {
        self.isFavorite.toggle()
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
