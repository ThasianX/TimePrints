//
//  Popsicle.swift
//  Locations App
//
//  Created by Kevin Li on 2/1/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct Popsicle: View {
    let color: Color
    
    var body: some View {
        Rectangle()
            .fill(color)
            .cornerRadius(50)
            .frame(width: 5, height: 30)
    }
}

struct Popsicle_Previews: PreviewProvider {
    static var previews: some View {
        Popsicle(color: .orange)
    }
}
