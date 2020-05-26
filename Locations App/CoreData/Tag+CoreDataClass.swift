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

    class var `default`: Tag {
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%d = isDefault", true)

        do {
            let defaultTag = try CoreData.stack.context.fetch(fetchRequest)
            return defaultTag.first!
        } catch {
            fatalError("Default tag not in database")
        }
    }
    
    class func fetchAll() -> [Tag] {
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()

        do {
            return try CoreData.stack.context.fetch(fetchRequest)
        } catch {
            fatalError("Tag entity does not exist in database")
        }
    }

    class func containsTag(with name: String, color: UIColor) -> Bool {
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.predicate = createTagPredicate(name: name, color: color.hexString())

        do {
            let queriedTag = try CoreData.stack.context.fetch(fetchRequest)
            return queriedTag.first != nil
        } catch {
            fatalError("Tag entity does not exist in database")
        }
    }

    private class func createTagPredicate(name: String, color: String) -> NSCompoundPredicate {
        let namePredicate = NSPredicate(format: "%@ == name", name)
        let colorPredicate = NSPredicate(format: "%@ == color", color)
        return NSCompoundPredicate(andPredicateWithSubpredicates: [namePredicate, colorPredicate])
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
    class func create(name: String, hex: String) -> Tag {
        let tag = newTag()
        tag.name = name
        tag.color = hex
        CoreData.stack.save()
        return tag
    }
}

extension Tag {
    func setAsDefault() {
        self.isDefault = true
        CoreData.stack.save()
    }

    func edit(name: String, color: UIColor) {
        self.name = name
        self.color = color.hexString()
        CoreData.stack.save()
    }

    func delete() {
        CoreData.stack.context.delete(self)
        CoreData.stack.save()
    }
}

extension Tag {
    var uiColor: UIColor {
        UIColor(self.color)
    }
}

extension Tag {
    class var preview: Tag {
        Tag.create(name: "Visits", color: .salmon)
    }
    
    class func deleteAll() {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Tag.fetchRequest())
        try! CoreData.stack.context.execute(batchDeleteRequest)
    }
}
