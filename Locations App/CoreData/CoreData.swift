//
//  CoreData.swift
//  Locations App
//
//  Created by Kevin Li on 1/28/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import CoreData
import SwiftUI

class CoreData: NSObject {
    static let stack = CoreData()
    
    // MARK: - Core Data Stack
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
    
    public var context: NSManagedObjectContext {
        get {
            return self.persistentContainer.viewContext
        }
    }
    
    // MARK: - Core Data Saving support
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
    
    // MARK: - Database Setup
    public class func initialDbSetup() {
        if Tag.count() == 0 {
            Tag.create(name: "Locations", color: UIColor.charcoal)
        }
        // TODO: Include Cloud KVS preference setup here?
    }
}
