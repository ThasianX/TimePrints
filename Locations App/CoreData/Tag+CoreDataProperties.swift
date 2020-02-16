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
    @NSManaged public var locations: Set<Location>?

}

// MARK: Generated accessors for locations
extension Tag {

    @objc(addLocationsObject:)
    @NSManaged public func addLocation(_ value: Location)

    @objc(removeLocationsObject:)
    @NSManaged public func removeLocation(_ value: Location)

    @objc(addLocations:)
    @NSManaged public func addLocations(_ values: Set<Location>)

    @objc(removeLocations:)
    @NSManaged public func removeLocations(_ values: Set<Location>)

}
