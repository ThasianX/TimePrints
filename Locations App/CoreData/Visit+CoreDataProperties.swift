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

extension Visit: Identifiable { }

extension Visit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Visit> {
        return NSFetchRequest<Visit>(entityName: "Location")
    }

    @NSManaged public var name: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var arrivalDate: Date
    @NSManaged public var departureDate: Date
    @NSManaged public var address: String
    @NSManaged public var notes: String
    @NSManaged public var isFavorite: Bool
    @NSManaged public var tag: Tag

}

