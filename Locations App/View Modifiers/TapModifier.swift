//
//  TapModifier.swift
//  Locations App
//
//  Created by Kevin Li on 2/3/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct TapModifier: ViewModifier {
    
    let action: () -> Void
    
    init(perform action: @escaping () -> Void) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    self.action()
                }
        }
    }
}
