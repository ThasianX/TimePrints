import SwiftUI

struct CloseRouteButton: View {
    @Binding var animatingExit: Bool
    let action: () -> Void

    var body: some View {
        closeRouteButton
    }

    private var closeRouteButton: some View {
        Button(action: closeRoute) {
            closeRouteFillImage
                .foregroundColor(.red)
        }
    }

    private func closeRoute() {
        animatingExit = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
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
        CloseRouteButton(animatingExit: .constant(false), action: { })
    }
}
