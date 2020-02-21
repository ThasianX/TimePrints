import CloudKit
import CoreData
import SwiftUI

class CoreData: NSObject {
    static let stack = CoreData()

    private lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Locations_App")
        
        container.persistentStoreDescriptions.first?
            .setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        get {
            return self.persistentContainer.viewContext
        }
    }

    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    class func initialDbSetup() {
        addDefaultTagIfDoesntExist()
        // TODO: Include Cloud KVS preference setup here?
    }

    private class func addDefaultTagIfDoesntExist() {
        let allRecords = NSPredicate(value: true)
        let tagQuery = CKQuery(recordType: "CD_Tag", predicate: allRecords)

        CKContainer.default().privateCloudDatabase.perform(tagQuery, inZoneWith: nil) { tags, error in
            if tags?.count == 0 {
                let tag = Tag.create(name: "Locations", color: .limeGreen)
                tag.setAsDefault()
            }
        }
    }
}
