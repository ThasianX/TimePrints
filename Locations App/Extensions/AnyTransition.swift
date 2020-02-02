//
//  AnyTransition.swift
//  Locations App
//
//  Created by Kevin Li on 2/2/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

extension AnyTransition {
    static var offsetScaleOpacity: AnyTransition {
        AnyTransition.offset(x: -600, y: 0).combined(with: .scale).combined(with: .opacity)
    }
    
    static var scaleAndOffset: AnyTransition {
        AnyTransition.asymmetric(insertion: .scale(scale: 0, anchor: .center), removal: .offset(x: -600, y: 0))
    }
}
