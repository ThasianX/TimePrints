// Kevin Li - 11:19 PM - 2/27/20

import SwiftUI

struct SplashScreen: View {
    let kingFisherDaisy = Color(.kingFisherDaisy)
    let iLineWidth: CGFloat = 5
    let iZoomFactor: CGFloat = 1.4
    let lineWidth: CGFloat = 4
    let lineHeight: CGFloat = 28
    let iSquareLength: CGFloat = 12

    @State private var percent = 0.0
    @State private var iScale: CGFloat = 1
    @State private var squareColor = Color.white
    @State private var squareScale: CGFloat = 1
    @State private var lineScale: CGFloat = 1
    @State private var textAlpha = 0.0
    @State private var textScale: CGFloat = 1
    @State private var pulseCircleScale: CGFloat = 1
    @State private var pulseCircleAlpha = 0.0

    @Binding var show: Bool

    var body: some View {
        ZStack {
            backgroundTiles
                .opacity(textAlpha)
                .scaleEffect(textScale)

            pulseCircle
                .scaleEffect(pulseCircleScale)
                .opacity(pulseCircleAlpha)

            timeText
                .opacity(textAlpha)
                .scaleEffect(textScale)
                .offset(x: -20)

            printsText
                .opacity(textAlpha)
                .scaleEffect(textScale)
                .offset(x: 0, y: 60)

            iAnimationView
                .onAppear(perform: handleAnimations)
                .scaleEffect(iScale * iZoomFactor)
                .offset(x: -35)

            iSquareView
                .onAppear(perform: setDefaultSquareColor)
                .scaleEffect(squareScale * iZoomFactor)
                .offset(x: -35)

            iRectangleView
                .scaleEffect(lineScale, anchor: .bottom)
                .offset(x: -35  , y: 22)
        }
        .background(kingFisherDaisy)
        .extendToScreenEdges()
    }

    private func setDefaultSquareColor() {
        squareColor = kingFisherDaisy
    }
}

private extension SplashScreen {
    private var backgroundTiles: some View {
        Image("tiles")
            .resizable(resizingMode: .tile)
    }

    private var pulseCircle: some View {
        Circle()
            .fill(kingFisherDaisy)
            .frame(width: 1, height: 1, alignment: .center)
    }

    private var timeText: some View {
        Text("T           ME")
            .font(.largeTitle)
            .foregroundColor(.white)
    }

    private var printsText: some View {
        Text("PRINTS")
            .tracking(7)
            .font(.largeTitle)
            .foregroundColor(.white)
    }

    private var iAnimationView: some View {
        IAnimation(percent: percent)
            .stroke(Color.white, lineWidth: iLineWidth)
            .rotationEffect(.degrees(-90))
            .aspectRatio(1, contentMode: .fit)
            .padding(20)
            .frame(width: 45, height: 45, alignment: .center)
    }

    private var iSquareView: some View {
        Rectangle()
            .fill(squareColor)
            .frame(width: iSquareLength, height: iSquareLength, alignment: .center)
    }

    private var iRectangleView: some View {
        Rectangle()
            .fill(kingFisherDaisy)
            .frame(width: lineWidth, height: lineHeight,
                   alignment: .center)
    }
}

private extension SplashScreen {
    var iAnimationDuration: Double { 1.0 }
    var iAnimationDelay: Double { 0.2 }
    var iExitAnimationDuration: Double { 0.3 }
    var finalAnimationDuration: Double { 0.4 }
    var minAnimationInterval: Double { 0.1 }
    var fadeAnimationDuration: Double { 0.6 }

    func handleAnimations() {
        runMainAnimation()
        runBackgroundPulseAnimation()
        fadeMainAnimation()
        endAnimation()
    }

    func runMainAnimation() {
        withAnimation(.easeIn(duration: iAnimationDuration)) {
            startIAnimation()
        }

        withAnimation(Animation.easeIn(duration: iAnimationDuration).delay(0.5)) {
            showText()
        }

        let deadline: DispatchTime = .now() + iAnimationDuration + iAnimationDelay
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            withAnimation(.easeOut(duration: self.iExitAnimationDuration)) {
                self.completeIAnimation()
            }
            withAnimation(.easeOut(duration: self.minAnimationInterval)) {
                self.shrinkSquare()
            }

            withAnimation(.spring()) {
                self.enlargeText()
            }
        }
    }

    private func startIAnimation() {
        percent = 1
        iScale = 5
        lineScale = 1
    }

    private func showText() {
        textAlpha = 1.0
    }

    private func completeIAnimation() {
        iScale = 0
        lineScale = 0
    }

    private func shrinkSquare() {
        squareScale = 0
    }

    private func enlargeText() {
        textScale = iZoomFactor
    }

    func runBackgroundPulseAnimation() {
        let deadline: DispatchTime = .now() + iAnimationDuration + iAnimationDelay + minAnimationInterval
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.enlargeWhiteSquare()
            withAnimation(.easeOut(duration: self.fadeAnimationDuration)) {
                self.startPulseAnimation()
            }
        }
    }

    private func enlargeWhiteSquare() {
        squareColor = Color.white
        squareScale = 1
    }

    private func startPulseAnimation() {
        pulseCircleAlpha = 1
        pulseCircleScale = 1000
    }

    func fadeMainAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2*iAnimationDuration) {
            withAnimation(.easeIn(duration: self.finalAnimationDuration)) {
                self.fadeTextAndResetSquareColor()
            }
        }
    }

    private func fadeTextAndResetSquareColor() {
        fadeText()
        setDefaultSquareColor()
    }

    private func fadeText() {
        textAlpha = 0
    }

    func endAnimation() {
        let deadline: DispatchTime = .now() + 2*iAnimationDuration + finalAnimationDuration
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.resetAnimation()
            withAnimation {
                self.exitView()
            }
        }
    }

    private func resetAnimation() {
        percent = 0
        textScale = 1
        pulseCircleAlpha = 0
        pulseCircleScale = 1
    }

    private func exitView() {
        show = false
    }
}

fileprivate struct IAnimation: Shape {
    var percent: Double

    func path(in rect: CGRect) -> Path {
        let end = percent * 360
        var p = Path()

        p.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.width/2),
                 radius: rect.size.width/2,
                 startAngle: Angle(degrees: 180),
                 endAngle: Angle(degrees: 180+end),
                 clockwise: false)

        return p
    }

    var animatableData: Double {
        get { percent }
        set { percent = newValue }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen(show: .constant(true))
    }
}
