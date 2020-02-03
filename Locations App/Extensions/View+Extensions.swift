//
//  View+Extensions.swift
//  Locations App
//
//  Created by Kevin Li on 1/31/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

extension View {
    func captureSize(in binding: Binding<CGSize>) -> some View {
        modifier(SizeModifier())
            .onPreferenceChange(SizePreferenceKey.self) {
                binding.wrappedValue = $0
        }
    }
    
    func rotated(_ angle: Angle) -> some View {
        modifier(RotatedModifier(angle: angle))
    }
    
    func beyond() -> some View {
        modifier(EdgeModifier())
    }
    
    func roundedFill(with color: Color) -> some View {
        modifier(BackgroundModifier(color: color))
    }
    
    func roundedFill(with color: UIColor) -> some View {
        modifier(BackgroundModifier(color: Color(color)))
    }
    
    func erase() -> AnyView {
        AnyView(self)
    }
}
