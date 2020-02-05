//
//  EditTagHeaderButtons.swift
//  Locations App
//
//  Created by Kevin Li on 2/5/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct EditTagHeaderButtons: View {
    @Binding var showAdd: Bool
    let showEdit: Bool
    let resetAddTag: () -> Void
    let resetEditTag: () -> Void
    let addNewTag: () -> Void
    let editTag: () -> Void
    let selectedColor: Color
    var body: some View {
        ZStack {
            BImage(condition: $showAdd, image: .init(systemName: "plus"))
                .foregroundColor(.white)
                .fade(showAdd || showEdit)
            HStack {
                BImage(action: showAdd ? resetAddTag : resetEditTag, image: .init(systemName: "xmark.circle.fill"))
                    .foregroundColor(.red)
                    .animation(.easeInOut)
                BImage(action: showAdd ? addNewTag : editTag, image: .init(systemName: "checkmark.circle.fill"))
                    .foregroundColor(.white)
                    .colorMultiply(selectedColor)
                    .animation(.easeInOut)
            }
            .fade(!showAdd && !showEdit)
        }
    }
}

struct EditTagHeaderButtons_Previews: PreviewProvider {
    static var previews: some View {
        EditTagHeaderButtons(showAdd: .constant(false), showEdit: false, resetAddTag: { }, resetEditTag: { }, addNewTag: { }, editTag: { }, selectedColor: Color(UIColor.salmon))
    }
}
