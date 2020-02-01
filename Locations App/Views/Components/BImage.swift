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
    let image: Image
    
    var body: some View {
        Button(action: {
            self.condition.toggle()
        }) {
            image
        }
    }
}

struct BImage_Previews: PreviewProvider {
    static var previews: some View {
        BImage(condition: .constant(false), image: .init(systemName: "arrow.left"))
    }
}
