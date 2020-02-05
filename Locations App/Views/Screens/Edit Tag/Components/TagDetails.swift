//
//  TagDetails.swift
//  Locations App
//
//  Created by Kevin Li on 2/5/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct TagDetails: View {
    @Binding var nameInput: String
    @Binding var selectedColorIndex: Int
    let colors: [String : UIColor]
    let identifiers: [String]
    
    var body: some View {
        VStack {
            TextField("Tag Name...", text: $nameInput)
                .padding(.init(top: 0, leading: 30, bottom: 0, trailing: 30))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
            Picker(selection: $selectedColorIndex, label: Text("")) {
                ForEach(0..<identifiers.count) {
                    ColoredTextRow(text: self.identifiers[$0], color: self.colors[self.identifiers[$0]]!, selected: false)
                }
            }
            .labelsHidden()
        }
    }
}

struct TagDetails_Previews: PreviewProvider {
    static var previews: some View {
        TagDetails(nameInput: .constant(""), selectedColorIndex: .constant(2), colors: AppColors.tags, identifiers: AppColors.tags.ascendingKeys)
    }
}
