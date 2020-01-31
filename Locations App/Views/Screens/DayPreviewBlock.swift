//
//  DayPreviewBlock.swift
//  Locations App
//
//  Created by Kevin Li on 1/31/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct DayPreviewBlock: View {
    let locations: [Location]
    @State private var locationsIndex = 0
    
    private var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            withAnimation {
                if self.locationsIndex < self.locations.count-3 {
                    self.locationsIndex += 3
                } else {
                    self.locationsIndex = 0
                }
            }
        }
    }
    
    private var range: Range<Int> {
        return locationsIndex ..< ((locationsIndex + 3 > locations.count) ? locations.count : locationsIndex + 3)
    }
    
    var body: some View {
        ZStack {
            Color.green.frame(height: 150)
            VStack(spacing: 0) {
                ForEach(locations[range]) { location in
                    LocationPreviewCell(location: location)
                }
                .animation(.easeInOut(duration: 0.5))
            }
        }
        .onAppear {
            let _ = self.timer
        }
    }
}

struct DayPreviewBlock_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DayPreviewBlock(locations: [])
            DayPreviewBlock(locations: [.preview])
            DayPreviewBlock(locations: [.preview, .preview])
            DayPreviewBlock(locations: [.preview, .preview, .preview])
            DayPreviewBlock(locations: [.preview, .preview, .preview, .preview])
            DayPreviewBlock(locations: [.preview, .preview, .preview, .preview, .preview, .preview, .preview, .preview, .preview, .preview, .preview])
        }
        .border(Color.black)
    }
}