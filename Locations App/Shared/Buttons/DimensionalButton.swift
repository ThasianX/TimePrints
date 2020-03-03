// Kevin Li - 12:01 PM - 3/3/20

import SwiftUI

fileprivate let ROTATION_AMOUNT: Double = 360
fileprivate let ROTATION_ANIMATION_DURATION: Double = 2
fileprivate let CHECKMARK_ANIMATION_DURATION: Double = 0.6

struct DimensionalButton: View {
    @State private var showFirstStroke = false
    @State private var showSecondStroke = false
    @State private var showCheckmark = false

    let image: Image
    let action: () -> Void
    let circleColor: Color

    var checkmarkCircleColor: Color = .green
    var checkmarkColor: Color = .white
    var radius: CGFloat = 25

    var body: some View {
        ZStack {
            firstCircleStroke
            secondCircleStroke
            image
                .resizable()
                .padding()
                .foregroundColor(checkmarkColor)
                .fade(if: showFirstStroke)
                .animation(.easeInOut)
            checkmarkView
        }
        .frame(width: circleDiameter, height: circleDiameter)
        .contentShape(Circle())
        .onTapGesture(perform: animateThenExecute)
    }

    private func animateThenExecute() {
        showFirstStroke = true
        showSecondStroke = true
        showCheckmark = true

        DispatchQueue.main.asyncAfter(deadline: .now() + ROTATION_ANIMATION_DURATION + CHECKMARK_ANIMATION_DURATION) {
            self.action()
        }
    }

    private var firstCircleStroke: some View {
        Circle()
            .strokeBorder(lineWidth: showFirstStroke ? checkmarkCircleWidth : radius, antialiased: false)
            .frame(width: circleDiameter, height: circleDiameter)
            .foregroundColor(showFirstStroke ? checkmarkCircleColor : circleColor)
            .rotation3DEffect(.degrees(showFirstStroke ? 0 : ROTATION_AMOUNT), axis: (x: 1, y: 1, z: 1))
            .animation(Animation.easeIn(duration: ROTATION_ANIMATION_DURATION))
    }

    private var secondCircleStroke: some View {
        Circle()
            .strokeBorder(lineWidth: showSecondStroke ? checkmarkCircleWidth : radius, antialiased: false)
            .frame(width: circleDiameter, height: circleDiameter)
            .foregroundColor(showSecondStroke ? checkmarkCircleColor : circleColor)
            .rotation3DEffect(.degrees(showSecondStroke ? 0 : ROTATION_AMOUNT), axis: (x: -1, y: 1, z: 1))
            .animation(Animation.easeIn(duration: ROTATION_ANIMATION_DURATION))
    }

    private var checkmarkView: some View {
        checkMarkPath
            .trim(from: 0, to: showCheckmark ? 1 : 0)
            .stroke(style: StrokeStyle(lineWidth: checkmarkLineWidth, lineCap: .round, lineJoin: .round))
            .foregroundColor(checkmarkColor)
            .animation(Animation.easeInOut.delay(ROTATION_ANIMATION_DURATION))
    }

    private var checkMarkPath: Path {
        Path { path in
            path.move(to: startingPoint)
            path.addLine(to: startingPoint)
            path.addLine(to: bottomPoint)
            path.addLine(to: endPoint)
        }
    }
}

private extension DimensionalButton {
    private var checkmarkCircleWidth: CGFloat {
        radius / 25
    }

    private var circleDiameter: CGFloat {
        radius * 2
    }

    private var checkmarkLineWidth: CGFloat {
        radius / 10
    }

    private var startingPoint: CGPoint {
        CGPoint(x: radius * 0.6, y: radius)
    }

    private var bottomPoint: CGPoint {
        CGPoint(x: radius * 0.9, y: radius * 1.3)
    }

    private var endPoint: CGPoint {
        CGPoint(x: radius * 1.5, y: radius * 0.7)
    }
}

struct DimensionalButton_Previews: PreviewProvider {
    static var previews: some View {
        DimensionalButton(image: Image(systemName: "arrow.right"), action: { }, circleColor: .blue)
    }
}
