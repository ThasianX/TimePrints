//
//  DisableModifier.swift
//  Locations App
//
//  Created by Kevin Li on 2/4/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct DisableModifier: ViewModifier {
    let disabled: Bool
    
    func body(content: Content) -> some View {
        content
            .blur(radius: disabled ? 20 : 0)
            .allowsHitTesting(!disabled)
    }
}
