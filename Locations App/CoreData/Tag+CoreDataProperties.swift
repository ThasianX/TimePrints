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
    @NSManaged public var visits: NSSet?

}

// MARK: Generated accessors for locations
extension Tag {

    @objc(addLocationsObject:)
    @NSManaged public func addVisit(_ value: Visit)

    @objc(removeLocationsObject:)
    @NSManaged public func removeVisit(_ value: Visit)

    @objc(addLocations:)
    @NSManaged public func addVisits(_ values: NSSet)

    @objc(removeLocations:)
    @NSManaged public func removeVisits(_ values: NSSet)

}
