//
//  TagContextMenu.swift
//  Locations App
//
//  Created by Kevin Li on 2/4/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct TagContextMenu: View {
    let tag: Tag
    let onEdit: (Tag) -> Void
    let onDelete: (Tag) -> Void
    
    var body: some View {
        VStack {
            Button(action: { self.onEdit(self.tag) }) {
                HStack {
                    Text("Edit")
                    Image(systemName: "pencil")
                }
            }
            
            Button(action: { self.onDelete(self.tag)}) {
                HStack {
                    Text("Delete")
                    Image(systemName: "trash.fill")
                }
            }
        }
    }
}

struct TagContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        TagContextMenu(tag: .preview, onEdit: { _ in }, onDelete: { _ in })
    }
}
