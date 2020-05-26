// Kevin Li - 8:48 PM - 5/23/20

import SwiftUI

struct RadarSpinnerView: View {
    @State private var rotateOuter = false
    @State private var rotateInner = false

    let radarColor: Color
    var radarSaturation: Double = 1
    var radarOpacity: Double = 1

    var body: some View {
        ZStack {
            outerImageView
            innerImageView
        }
        .foregroundColor(radarColor)
        .saturation(radarSaturation)
        .opacity(radarOpacity)
    }

    private var outerImageView: some View {
        Image("outer")
            .rotationEffect(.degrees(rotateInner ? -180 : 0))
            .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true))
            .onAppear(perform: toggleOuterRotation)
    }

    private func toggleOuterRotation() {
        rotateOuter.toggle()
    }

    private var innerImageView: some View {
        Image("inner")
            .rotationEffect(.degrees(rotateInner ? 180 : 0))
            .animation(Animation.easeOut(duration: 1).repeatForever(autoreverses: true))
            .onAppear(perform: toggleInnerRotation)
    }

    private func toggleInnerRotation() {
        rotateInner.toggle()
    }
}
