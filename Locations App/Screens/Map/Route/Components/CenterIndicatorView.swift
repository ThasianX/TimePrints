import SwiftUI

struct CenterIndicatorView: View {
    @Binding var locationControl: AppState.LocationControl
    @Binding var route: AppState.Route
    let color: Color

    var body: some View {
        ZStack {
            centerIndicator
                .scaleEffect(route.isCentered ? 1 : 0.1)
                .fade(if: !route.isCentered)
            recenterMapButton
                .scaleEffect(!route.isCentered ? 1 : 0.1)
                .fade(if: route.isCentered)
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
    }

    private var centerIndicator: some View {
        Image(systemName: "triangle.fill")
            .asIndicator(with: color)
    }

    private var recenterMapButton: some View {
        Button(action: recenterMap) {
            Image(systemName: "mappin.circle.fill")
                .asIndicator(with: color)
        }
    }

    private func recenterMap() {
        route.recenter()
    }
}

private extension Image {
    func asIndicator(with color: Color) -> some View {
        self
            .resizable()
            .frame(width: 15, height: 15)
            .foregroundColor(color)
    }
}

struct CenterIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        CenterIndicatorView(locationControl: .constant(.init()), route: .constant(.init()), color: .blue)
    }
}
