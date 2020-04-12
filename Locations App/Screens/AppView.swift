import Mapbox
import SwiftUI

struct AppView: View {
    @Environment(\.appTheme) private var appTheme: UIColor

    @ObservedObject private var appState: AppState = .init()

    let onAppear: () -> Void

    var body: some View {
        Group {
            visitsHomeView
                .fade(if: !appState.showing.homeView)

            appMapView
                .fade(if: appState.showing.homeView)
                .onAppear(perform: onAppear)

            toggleViewButton
                .fade(if: !appState.showing.toggleButton)
        }
    }

    private var visitsHomeView: some View {
        VisitsHomeView(appState: appState)
    }

    private var appMapView: some View {
        AppMapView(appState: appState)
    }

    private var toggleViewButton: some View {
        ToggleButton(condition: appState.showing.homeView, action: toggleVisitsPreviewAndStayAtLocation)
    }

    private func toggleVisitsPreviewAndStayAtLocation() {
        appState.locationControl.reset(stayAtCurrent: true)
        appState.showing.homeView.toggle()
        appState.route.reset()
    }
}

private extension AppView {
    private struct ToggleButton: View {
        let condition: Bool
        let action: () -> Void

        var body: some View {
            ZStack {
                backgroundColor
                BImage(perform: action, image: image)
                    .foregroundColor(foregroundColor)
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
        }

        private var backgroundColor: Color {
            condition ? .green : .white
        }

        private var image: Image {
            condition ? Image(systemName: "map.fill") : Image(systemName: "list.dash")
        }

        private var foregroundColor: Color {
            condition ? .white : .black
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(onAppear: { })
    }
}
