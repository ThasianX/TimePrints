//
//  ColorTextRow.swift
//  Locations App
//
//  Created by Kevin Li on 2/5/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct ColoredTextRow: View {
    let text: String
    let color: UIColor
    let selected: Bool
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color(color))
                .frame(width: 20, height: 20)
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(nil)
            Spacer()
            if selected {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
            }
        }
        .padding(.init(top: 0, leading: 32, bottom: 0, trailing: 0))
    }
}

struct ColorTextRow_Previews: PreviewProvider {
    static var previews: some View {
        ColoredTextRow(text: "Salmon", color: .salmon, selected: true)
    }
}
