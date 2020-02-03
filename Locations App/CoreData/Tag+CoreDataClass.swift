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
    // MARK: Class Functions
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
        fetchRequest.predicate = NSPredicate(format: "%@ == name", "Places")
        
        do {
            let tag = try CoreData.stack.context.fetch(fetchRequest)
            return tag.first!
        } catch {
            fatalError("Default tag not in database")
        }
    }
    
    private class func newTag() -> Tag {
        Tag(context: CoreData.stack.context)
    }
    
    @discardableResult
    class func create(name: String, color: UIColor) -> Tag {
        let tag = newTag()
        tag.name = name
        tag.color = color.hexString()
        CoreData.stack.save()
        
        return tag
    }
    
    // MARK: Local Functions
    func edit(name: String, color: UIColor) {
        self.name = name
        self.color = color.hexString()
        CoreData.stack.save()
    }
    
    func delete() -> Tag {
        let tag = self
        CoreData.stack.context.delete(self)
        return tag
    }
}

extension Tag {
    // MARK: - Preview
    class var preview: Tag {
        Tag.create(name: "Visits", color: .salmon)
    }
}
