//
//  EditTagHeader.swift
//  Locations App
//
//  Created by Kevin Li on 2/5/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct EditTagHeaderText: View {
    let showAdd: Bool
    let showEdit: Bool
    let selectedColor: Color
    let location: Location?
    
    var body: some View {
        HStack {
            Image(systemName: "tag.fill")
                .foregroundColor(.white)
                .colorMultiply((showAdd || showEdit) ? selectedColor : (location != nil ? Color(location!.accent) : .clear))
                .animation(.easeInOut)
            ZStack {
                Text("CHOOSE TAG")
                    .tracking(5)
                    .font(.system(size: 20))
                    .bold()
                    .fade(showAdd || showEdit)
                Text("MAKE TAG")
                    .tracking(5)
                    .font(.system(size: 20))
                    .bold()
                    .fade(!showAdd)
                Text("EDIT TAG")
                    .tracking(5)
                    .font(.system(size: 20))
                    .bold()
                    .fade(!showEdit)
            }
            .foregroundColor(.white)
            .animation(.easeInOut)
        }
    }
}

struct EditTagHeader_Previews: PreviewProvider {
    static var previews: some View {
        EditTagHeaderText(showAdd: false, showEdit: false, selectedColor: Color(UIColor.salmon), location: .preview)
    }
}
