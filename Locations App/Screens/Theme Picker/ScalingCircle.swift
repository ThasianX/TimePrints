// Kevin Li - 10:44 AM - 3/2/20

import SwiftUI

struct ScalingCircle: View {
    @State private var scaleAll = false
    @State private var rotateOuter = false

    var body: some View {
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
            .animation(Animation.spring(response: 1.75, dampingFraction: 0.8, blendDuration: 0.3))
        }
        .scaleEffect(scaleAll ? 1 : 0.3)
        .animation(Animation.easeInOut(duration: 1.5))
        .onTapGesture {
            self.scaleAll.toggle()
            self.rotateOuter.toggle()
        }
    }
}

struct ScalingCircle_Previews: PreviewProvider {
    static var previews: some View {
        ScalingCircle()
    }
}
