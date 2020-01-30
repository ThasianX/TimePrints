//
//  Tag+CoreDataProperties.swift
//  Locations App
//
//  Created by Kevin Li on 1/28/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//
//

import Foundation
import CoreData

extension Tag: Identifiable { }

extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var name: String
    @NSManaged public var color: String
    @NSManaged public var locations: NSSet?

}

// MARK: Generated accessors for locations
extension Tag {

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: Location)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: Location)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: NSSet)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: NSSet)

}
