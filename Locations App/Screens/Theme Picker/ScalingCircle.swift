// Kevin Li - 10:44 AM - 3/2/20

import SwiftUI

struct ScalingCircle: View {
    @State private var scaleAll = false
    @State private var rotateOuter = false

    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color.black
                , Color.blue]), center: .center, startRadius: 5, endRadius: 500)
                .scaleEffect(1.2)
            ZStack {

                Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                ZStack {
                    Circle()  //
                        .trim(from: 1/2, to: 4/5)
                        .stroke(style: .init(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    Circle()  //
                        .trim(from: 1/2, to: 4/5)
                        .stroke(style: .init(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(180))

                }
                .rotationEffect(.degrees(rotateOuter ? 360*3 : 0))
                .animation(Animation.spring(response: 0.87, dampingFraction: 0.1, blendDuration: 0.3).repeatForever(autoreverses: true))
                .onAppear() {
                    self.rotateOuter.toggle()
                }
            }.scaleEffect(scaleAll ? 1 : 0.3)
            .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
            .onAppear() {
                self.scaleAll.toggle()
            }
        }
    }
}

struct ScalingCircle_Previews: PreviewProvider {
    static var previews: some View {
        ScalingCircle()
    }
}
