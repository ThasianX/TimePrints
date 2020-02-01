//
//  RotatedModifier.swift
//  Locations App
//
//  Created by Kevin Li on 1/31/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct RotatedModifier: ViewModifier {
    @State private var size: CGSize = .zero
    var angle: Angle
    
    func body(content: Content) -> some View {
        let newFrame = CGRect(origin: .zero, size: size)
            .offsetBy(dx: -size.width / 2, dy: -size.height / 2)
            .applying(.init(rotationAngle: CGFloat(angle.radians)))
            .integral
        
        return content
            .fixedSize()
            .captureSize(in: $size)
            .rotationEffect(angle)
            .frame(width: newFrame.width, height: newFrame.height)
    }
}
