import SwiftUI

struct NextLocationButton: View {
    @Binding var route: AppState.Route

    let color: Color

    private var isAtEnd: Bool {
        route.isAtEnd
    }

    var body: some View {
        Button(action: goToNextLocation) {
            nextLocationFillImage
                .foregroundColor(color)
                .rotationEffect(isAtEnd ? .init(degrees: -180) : .init(degrees: 0))
                .animation(.spring(response: 0.75, dampingFraction: 0.825, blendDuration: 0))
        }
    }

    private func goToNextLocation() {
        if isAtEnd {
            route.restart()
        } else {
            route.selectNextLocation()
        }
    }

    private var nextLocationFillImage: some View {
        Image(systemName: "forward.fill")
            .resizable()
            .frame(width: 20, height: 20)
    }
}

struct NextLocationButton_Previews: PreviewProvider {
    static var previews: some View {
        NextLocationButton(route: .constant(.init()), color: .pink)
    }
}
