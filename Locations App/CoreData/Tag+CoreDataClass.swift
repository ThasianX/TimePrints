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
    // MARK: CRUD
    private class func newTag() -> Tag {
        Tag(context: CoreData.stack.context)
    }
    
    class func create(name: String, color: Color) -> Tag {
        let tag = newTag()
        tag.name = name
        tag.color = color.toHex()
        CoreData.stack.save()
        
        return tag
    }
    
    func edit(name: String, color: Color) {
        self.name = name
        self.color = color.toHex()
        CoreData.stack.save()
    }
}
