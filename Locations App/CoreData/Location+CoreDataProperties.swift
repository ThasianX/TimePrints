import Foundation
import CoreData

extension Location: Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }
    
    @NSManaged public var name: String
    @NSManaged public var address: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var tag: Tag
    @NSManaged public var visits: Set<Visit>
}

extension Location {
    @objc(addVisitsObject:)
    @NSManaged public func addVisit(_ value: Visit)
    
    @objc(removeVisitsObject:)
    @NSManaged public func removeVisit(_ value: Visit)
    
    @objc(addVisits:)
    @NSManaged public func addVisits(_ values: Set<Visit>)
    
    @objc(removeVisits:)
    @NSManaged public func removeVisits(_ values: Set<Visit>)
}

