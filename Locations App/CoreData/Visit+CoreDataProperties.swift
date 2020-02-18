import Foundation
import CoreData

extension Visit: Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Visit> {
        return NSFetchRequest<Visit>(entityName: "Visit")
    }

    @NSManaged public var arrivalDate: Date
    @NSManaged public var departureDate: Date?
    @NSManaged public var notes: String
    @NSManaged public var isFavorite: Bool
    @NSManaged public var location: Location
}

