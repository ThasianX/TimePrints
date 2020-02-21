import Foundation
import CoreData

extension Tag: Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var name: String
    @NSManaged public var color: String
    @NSManaged public var isDefault: Bool
    @NSManaged public var locations: Set<Location>?
}

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
