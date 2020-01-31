//
//  Tag+CoreDataClass.swift
//  Locations App
//
//  Created by Kevin Li on 1/28/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(Tag)
public class Tag: NSManagedObject {
    
    class func count() -> Int {
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        
        do {
            let count = try CoreData.stack.context.count(for: fetchRequest)
            return count
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    class func getDefault() -> Tag {
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%@ == name", "Visits")
        
        do {
            let a = try CoreData.stack.context.fetch(fetchRequest)
            return a.first!
        } catch {
            fatalError("Default tag not in database")
        }
    }
    
    // MARK: CRUD
    private class func newTag() -> Tag {
        Tag(context: CoreData.stack.context)
    }
    
    @discardableResult
    class func create(name: String, color: Color) -> Tag {
        let tag = newTag()
        tag.name = name
        tag.color = "charcoal"
        CoreData.stack.save()
        
        return tag
    }
    
    func edit(name: String, color: Color) {
        self.name = name
        self.color = color.hexForTag()
        CoreData.stack.save()
    }
    
    func delete() -> Tag {
        let tag = self
        CoreData.stack.context.delete(self)
        return tag
    }
}
