//
//  V0Stack.swift
//  Locations App
//
//  Created by Kevin Li on 1/31/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct V0Stack<Content: View>: View {
    private let content: Content
    
    @inlinable init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            content
        }
    }
}

struct V0Stack_Previews: PreviewProvider {
    static var previews: some View {
        V0Stack {
            Text("A")
            Text("B")
            Text("C")
        }
    }
}
