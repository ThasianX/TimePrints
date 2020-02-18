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
        fetchRequest.predicate = NSPredicate(format: "%@ == name", "Locations")
        
        do {
            let tag = try CoreData.stack.context.fetch(fetchRequest)
            return tag.first!
        } catch {
            fatalError("Default tag not in database")
        }
    }
    
    class func fetchAll() -> [Tag] {
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()

        return try! CoreData.stack.context.fetch(fetchRequest)
    }
    
    class func newTag() -> Tag {
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
    
    @discardableResult
    class func create(from existing: Tag) -> Tag {
        let tag = newTag()
        tag.name = existing.name
        tag.color = existing.color
        CoreData.stack.save()
        return tag
    }
}

extension Tag {
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
    var uiColor: UIColor {
        UIColor(self.color)
    }
}

extension Tag {
    // MARK: - Preview
    class var preview: Tag {
        Tag.create(name: "Visits", color: .salmon)
    }
    
    class func deleteAll() {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Tag.fetchRequest())
        try! CoreData.stack.context.execute(batchDeleteRequest)
    }
}
