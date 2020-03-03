// Kevin Li - 10:44 AM - 3/2/20

import SwiftUI

fileprivate let ROTATION_DEGREES: Double = 1080
fileprivate let ANIMATION_DURATION: Double = 1.5
fileprivate let UNSELECTED_SCALE_FACTOR: CGFloat = 0.5

struct ScalingCircle: View {
    @Binding var selectedColor: UIColor
    let uiColor: UIColor

    private var isSelected: Bool {
        uiColor == selectedColor
    }

    var body: some View {
        ZStack {
            innerCircle
            outerRing
                .rotationEffect(.degrees(isSelected ? ROTATION_DEGREES : 0))
                .animation(.spring(response: ANIMATION_DURATION + 0.25, dampingFraction: 0.8, blendDuration: 0.3))
        }
        .scaleEffect(isSelected ? 1 : UNSELECTED_SCALE_FACTOR)
        .animation(.easeInOut(duration: ANIMATION_DURATION))
        .onTapGesture(perform: setAsSelectedIndex)
    }

    private func setAsSelectedIndex() {
        selectedColor = uiColor
    }
}

private extension ScalingCircle {
    private var innerCircle: some View {
        Circle()
            .frame(width: 50, height: 50)
            .foregroundColor(uiColor.color)
    }

    private var outerRing: some View {
        ZStack {
            topArc
            bottomArc
        }
    }

    private var topArc: some View {
        semiArc
            .foregroundColor(.white)
    }

    private var bottomArc: some View {
        semiArc
            .foregroundColor(uiColor.color)
            .rotationEffect(.degrees(180))
    }

    private var semiArc: some View {
        Circle()
            .trim(from: 1/2, to: 4/5)
            .stroke(style: .init(lineWidth: 3, lineCap: .round, lineJoin: .round))
            .frame(width: 100, height: 100)
    }
}

struct ScalingCircle_Previews: PreviewProvider {
    static var previews: some View {
        // idk why the binding doesn't work
        ScalingCircle(selectedColor: .constant(.red), uiColor: .blue)
    }
}
