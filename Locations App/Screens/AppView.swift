import Mapbox
import SwiftUI

struct AppView: View {
    @Environment(\.appTheme) private var appTheme: UIColor

    @State private var showingToggleButton: Bool = true
    @State private var stayAtLocation: Bool = false
    @State private var showingHomeView: Bool = false
    @State private var activeVisitLocation: Location? = nil
    @ObservedObject private var activeRoute: ActiveRoute = .init()

    let onAppear: () -> Void

    var body: some View {
        Group {
            visitsHomeView
                .fade(if: !showingHomeView)

            appMapView
                .fade(if: showingHomeView)
                .onAppear(perform: onAppear)

            toggleViewButton
                .fade(if: !showingToggleButton)
        }
    }

    private var visitsHomeView: some View {
        VisitsHomeView(showingHomeView: $showingHomeView, activeVisitLocation: $activeVisitLocation, activeRoute: activeRoute)
    }

    private var appMapView: some View {
        AppMapView(showingToggleButton: $showingToggleButton, stayAtLocation: $stayAtLocation, activeVisitLocation: $activeVisitLocation, activeRoute: activeRoute)
    }

    private var toggleViewButton: some View {
        ToggleButton(toggle: showingHomeView, action: toggleVisitsPreviewAndStayAtLocation)
    }

    private func toggleVisitsPreviewAndStayAtLocation() {
        activeVisitLocation = nil
        showingHomeView.toggle()
        stayAtLocation = true
        activeRoute.reset()
    }
}

private extension AppView {
    private struct ToggleButton: View {
        let toggle: Bool
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
            toggle ? .green : .white
        }

        private var image: Image {
            toggle ? Image(systemName: "map.fill") : Image(systemName: "list.dash")
        }

        private var foregroundColor: Color {
            toggle ? .white : .black
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(onAppear: { })
    }
}
