//
//  Location+CoreDataProperties.swift
//  Locations App
//
//  Created by Kevin Li on 1/28/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var name: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var arrivalDate: Date
    @NSManaged public var departureDate: Date
    @NSManaged public var address: String
    @NSManaged public var notes: String
    @NSManaged public var favorited: Bool
    @NSManaged public var tag: Tag

}
