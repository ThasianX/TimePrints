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
        addDefaultTag()
    }

    private class func addDefaultTag() {
        let tag = Tag.create(name: "Locations", color: .limeGreen)
        tag.setAsDefault()
    }
}
