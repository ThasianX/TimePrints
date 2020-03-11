import SwiftUI

struct CloseRouteButton: View {
    @ObservedObject var activeRoute: ActiveRoute
    @Binding var stayAtLocation: Bool

    var body: some View {
        Button(action: closeRoute) {
            closeRouteFillImage
                .foregroundColor(.red)
        }
    }

    private func closeRoute() {
        activeRoute.reset()
        stayAtLocation = true
    }

    private var closeRouteFillImage: some View {
        Image(systemName: "stop.fill")
            .resizable()
            .frame(width: 30, height: 30)
    }
}

struct CloseRouteButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseRouteButton(activeRoute: .init(), stayAtLocation: .constant(false))
    }
}
