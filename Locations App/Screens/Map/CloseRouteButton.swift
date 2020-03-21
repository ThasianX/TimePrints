import SwiftUI

struct CloseRouteButton: View {
    @State private var animateExit: Bool = false
    let action: () -> Void

    var body: some View {
        closeRouteButton
            .scaleEffect(animateExit ? 0 : 1)
            .rotationEffect(animateExit ? Angle(degrees: 360) : Angle(degrees : 0))
            .animation(.spring())
    }

    private var closeRouteButton: some View {
        Button(action: closeRoute) {
            closeRouteFillImage
                .foregroundColor(.red)
        }
    }

    private func closeRoute() {
        animateExit = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.action()
        }
    }

    private var closeRouteFillImage: some View {
        Image(systemName: "xmark")
            .resizable()
            .frame(width: 20, height: 20)
    }
}

struct CloseRouteButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseRouteButton(action: { })
    }
}
