//
//  BackgroundModifier.swift
//  Locations App
//
//  Created by Kevin Li on 2/1/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct BackgroundModifier: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content.background(RoundedRectangle(cornerRadius: 16).stroke(color).background(color).cornerRadius(16))
    }
}
