//
//  DayPreviewBlock.swift
//  Locations App
//
//  Created by Kevin Li on 1/31/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct DayPreviewBlock: View {
    @State private var visitIndex = 0
    let visits: [Visit]
    let isFilled: Bool
    
    private var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            withAnimation {
                if self.visitIndex < self.visits.count-3 {
                    self.visitIndex += 3
                } else {
                    self.visitIndex = 0
                }
            }
        }
    }
    
    private var range: Range<Int> {
        return visitIndex ..< ((visitIndex + 3 > visits.count) ? visits.count : visitIndex + 3)
    }
    
    var body: some View {
        ZStack {
            if isFilled {
                Color("salmon").saturation(2).frame(height: 150)
            } else {
                Color("salmon").frame(height: 150)
            }
            VStack(spacing: 0) {
                ForEach(visits[range]) { visit in
                    VisitPreviewCell(visit: visit)
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
            DayPreviewBlock(visits: [], isFilled: false)
            DayPreviewBlock(visits: [.preview], isFilled: false)
            DayPreviewBlock(visits: [.preview, .preview], isFilled: false)
            DayPreviewBlock(visits: [.preview, .preview, .preview], isFilled: false)
            DayPreviewBlock(visits: [.preview, .preview, .preview, .preview], isFilled: false)
            DayPreviewBlock(visits: [.preview, .preview, .preview, .preview, .preview, .preview, .preview, .preview, .preview, .preview, .preview], isFilled: false)
        }
    }
}
