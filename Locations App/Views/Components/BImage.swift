//
//  BImage.swift
//  Locations App
//
//  Created by Kevin Li on 2/1/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct BImage: View {
    @Binding var condition: Bool
    let action: () -> Void
    let image: Image
    
    init(condition: Binding<Bool>, image: Image) {
        self._condition = condition
        self.action = {}
        self.image = image
    }
    
    init(action: @escaping () -> Void, image: Image) {
        self._condition = .constant(false)
        self.action = action
        self.image = image
    }
    
    var body: some View {
        Button(action: {
            self.condition.toggle()
            self.action()
        }) {
            image
                .imageScale(.large)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BImage_Previews: PreviewProvider {
    static var previews: some View {
        BImage(condition: .constant(false), image: .init(systemName: "arrow.left")).previewLayout(.sizeThatFits)
    }
}
