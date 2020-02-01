//
//  SuperColor.swift
//  Locations App
//
//  Created by Kevin Li on 1/31/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct SuperColor: View {
    let color: Color
    
    @inlinable init(_ color: Color) {
        self.color = color
    }
    
    var body: some View {
        color.beyond()
    }
}

struct SuperColor_Previews: PreviewProvider {
    static var previews: some View {
        SuperColor(.black)
    }
}
