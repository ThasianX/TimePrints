// Kevin Li - 11:19 PM - 2/27/20

import SwiftUI

struct SplashScreen: View {
    let kingFisherDaisy = Color(.kingFisherDaisy)
    let iLineWidth: CGFloat = 5
    let iZoomFactor: CGFloat = 1.4
    let lineWidth:  CGFloat = 4
    let lineHeight: CGFloat = 28
    let iSquareLength: CGFloat = 12

    @State private var percent = 0.0
    @State private var iScale: CGFloat = 1
    @State private var squareColor = Color.white
    @State private var squareScale: CGFloat = 1
    @State private var lineScale: CGFloat = 1
    @State private var textAlpha = 0.0
    @State private var textScale: CGFloat = 1
    @State private var coverCircleScale: CGFloat = 1
    @State private var coverCircleAlpha = 0.0
    @State private var logoImageAlpha = 0.0
    @State private var logoImageScale: CGFloat = 1

    @Binding var show: Bool

    var body: some View {
        ZStack {
            Image("tiles")
                .resizable(resizingMode: .tile)
                .opacity(textAlpha)
                .scaleEffect(textScale)

            Circle()
                .fill(kingFisherDaisy)
                .frame(width: 1, height: 1,
                       alignment: .center)
                .scaleEffect(coverCircleScale)
                .opacity(coverCircleAlpha)

            Text("T           ME")
                .font(.largeTitle)
                .foregroundColor(.white)
                .opacity(textAlpha)
                .scaleEffect(textScale)
                .offset(x: -20)

            Image("footprints")
                .renderingMode(.template)
                .resizable()
                .frame(width: 40, height: 40)
                .offset(x: 90)
                .foregroundColor(.white)
                .opacity(logoImageAlpha)
                .scaleEffect(logoImageScale)

            IAnimation(percent: percent)
                .stroke(Color.white, lineWidth: iLineWidth)
                .rotationEffect(.degrees(-90))
                .aspectRatio(1, contentMode: .fit)
                .padding(20)
                .onAppear() {
                    self.handleAnimations()
            }
            .scaleEffect(iScale * iZoomFactor)
            .frame(width: 45, height: 45,
                   alignment: .center)
            .offset(x: -35)

            Rectangle()
                .fill(squareColor)
                .scaleEffect(squareScale * iZoomFactor)
                .frame(width: iSquareLength, height: iSquareLength,
                       alignment: .center)
                .offset(x: -35)
                .onAppear() {
                    self.squareColor = self.kingFisherDaisy
            }

            Rectangle()
                .fill(kingFisherDaisy)
                .scaleEffect(lineScale, anchor: .bottom)
                .frame(width: lineWidth, height: lineHeight,
                       alignment: .center)
                .offset(x: -35  , y: 22)

            Spacer()
        }
        .background(kingFisherDaisy)
        .edgesIgnoringSafeArea(.all)
    }
}

extension SplashScreen {
    var iAnimationDuration: Double { return 1.0 }
    var iAnimationDelay: Double { return  0.2 }
    var iExitAnimationDuration: Double { return 0.3 }
    var finalAnimationDuration: Double { return 0.4 }
    var minAnimationInterval: Double { return 0.1 }
    var fadeAnimationDuration: Double { return 0.6 }

    func handleAnimations() {
        runAnimationPart1()
        runAnimationPart2()
        runAnimationPart3()
        endAnimation()
    }

    func runAnimationPart1() {
        withAnimation(.easeIn(duration: iAnimationDuration)) {
            percent = 1
            iScale = 5
            lineScale = 1
        }

        withAnimation(Animation.easeIn(duration: iAnimationDuration).delay(0.5)) {
            textAlpha = 1.0
        }

        let deadline: DispatchTime = .now() + iAnimationDuration + iAnimationDelay
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            withAnimation(.easeOut(duration: self.iExitAnimationDuration)) {
                self.iScale = 0
                self.lineScale = 0
            }
            withAnimation(.easeOut(duration: self.minAnimationInterval)) {
                self.squareScale = 0
            }

            withAnimation(Animation.spring()) {
                self.textScale = self.iZoomFactor
            }
        }
    }

    func runAnimationPart2() {
        let deadline: DispatchTime = .now() + iAnimationDuration + iAnimationDelay + minAnimationInterval
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.squareColor = Color.white
            self.squareScale = 1
            withAnimation(.easeOut(duration: self.fadeAnimationDuration)) {
                self.logoImageAlpha = 1
                self.logoImageScale = self.iZoomFactor
                self.coverCircleAlpha = 1
                self.coverCircleScale = 1000
            }
        }
    }

    func runAnimationPart3() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2*iAnimationDuration) {
            withAnimation(.easeIn(duration: self.finalAnimationDuration)) {
                self.textAlpha = 0
                self.squareColor = self.kingFisherDaisy
                self.logoImageAlpha = 0
            }
        }
    }

    func endAnimation() {
        let deadline: DispatchTime = .now() + 2*iAnimationDuration + finalAnimationDuration
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.percent = 0
            self.textScale = 1
            self.coverCircleAlpha = 0
            self.coverCircleScale = 1
            self.logoImageScale = 1
            withAnimation {
                self.show = false
            }
        }
    }
}

struct IAnimation: Shape {
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
        get { return percent }
        set { percent = newValue }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen(show: .constant(true))
    }
}
