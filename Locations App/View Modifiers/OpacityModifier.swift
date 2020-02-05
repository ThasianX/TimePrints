//
//  OpacityModifier.swift
//  Locations App
//
//  Created by Kevin Li on 2/4/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct OpacityModifier: ViewModifier {
    let fade: Bool
    
    func body(content: Content) -> some View {
        content
            .opacity(fade ? 0 : 1)
    }
}
