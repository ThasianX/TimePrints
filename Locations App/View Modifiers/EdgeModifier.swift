//
//  EdgeModifier.swift
//  Locations App
//
//  Created by Kevin Li on 1/31/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct EdgeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.edgesIgnoringSafeArea(.all)
    }
}
