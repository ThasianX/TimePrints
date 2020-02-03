//
//  UserLocationButton.swift
//  Locations App
//
//  Created by Kevin Li on 2/2/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI
import Mapbox

struct UserLocationButton: View {
    @Binding var trackingMode: MGLUserTrackingMode
    
    var shouldRotate: Bool {
        trackingMode == .followWithHeading
    }
    
    var body: some View {
        Button(action: updateTrackingMode) {
            Image(systemName: "location.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .rotationEffect(shouldRotate ? .init(degrees: -45) : .init(degrees: 0))
                .animation(.spring(response: 0.75, dampingFraction: 0.825, blendDuration: 0))
        }
    }
    
    private func updateTrackingMode() {
        var mode: MGLUserTrackingMode
        
        switch trackingMode {
        case .follow:
            mode = .followWithHeading
        case .followWithHeading:
            mode = .follow
        default:
            fatalError("Other tracking modes not supported")
        }
        
        withAnimation {
            self.trackingMode = mode
        }
    }
}

struct UserLocationButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UserLocationButton(trackingMode: .constant(.follow))
            UserLocationButton(trackingMode: .constant(.followWithHeading))
        }
    }
}
