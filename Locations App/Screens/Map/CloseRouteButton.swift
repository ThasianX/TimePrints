import SwiftUI

struct CloseRouteButton: View {
    @Binding var route: AppState.Route

    var body: some View {
        Button(action: closeRoute) {
            closeRouteFillImage
                .foregroundColor(.red)
        }
    }

    private func closeRoute() {
        route.reset()
    }

    private var closeRouteFillImage: some View {
        Image(systemName: "stop.fill")
            .resizable()
            .frame(width: 20, height: 20)
    }
}

struct CloseRouteButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseRouteButton(route: .constant(.init()))
    }
}
