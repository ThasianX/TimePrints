import SwiftUI

struct NextLocationButton: View {
    @ObservedObject var activeRoute: ActiveRoute
    @Binding var stayAtLocation: Bool

    let color: Color

    var body: some View {
        Button(action: goToNextLocation) {
            nextLocationFillImage
                .foregroundColor(color)
                .rotationEffect(activeRoute.isAtEnd ? .init(degrees: -180) : .init(degrees: 0))
                .animation(.spring(response: 0.75, dampingFraction: 0.825, blendDuration: 0))
        }
    }

    private func goToNextLocation() {
        stayAtLocation = true
        if activeRoute.isAtEnd {
            activeRoute.restart()
        } else {
            activeRoute.selectNextLocation()
        }
    }

    private var nextLocationFillImage: Image {
        Image(systemName: "forward.fill")
    }
}

struct NextLocationButton_Previews: PreviewProvider {
    static var previews: some View {
        NextLocationButton(activeRoute: .init(), stayAtLocation: .constant(false), color: .pink)
    }
}
