import Mapbox
import SwiftUI

struct AppMapView: View {
    @Environment(\.appTheme) private var appTheme: UIColor
    @FetchRequest(entity: Location.entity(), sortDescriptors: []) var locations: FetchedResults<Location>

    @State private var trackingMode: MGLUserTrackingMode = .follow
    @State private var mapState: MapState = .showingMap

    @ObservedObject var appState: AppState

    private var routeExists: Bool {
        appState.route.exists
    }

    var body: some View {
        ZStack(alignment: .top) {
            Group {
                mapView
                    .extendToScreenEdges()
                buttonHeader
                    .fade(if: routeExists)
                    .blurBackground(if: routeExists)
            }
            .disablur(!mapState.isShowingMap)

            Group {
                if routeExists {
                    routeOverlayView
                }
            }
            .scaleFade(if: !routeExists)

            editTagView
                .modal(isPresented: mapState.isShowingEditTag)

            locationVisitsView
                .modal(isPresented: mapState.isshowingLocationVisits)

        }
    }

    private var mapView: some View {
        MapView(
            mapState: $mapState,
            trackingMode: $trackingMode,
            appState: appState,
            userLocationColor: appTheme,
            annotations: locations.map(LocationAnnotation.init)
        )
    }

    private var buttonHeader: some View {
        HStack {
            userLocationButton
            Spacer()
        }
        .padding()
    }

    private var userLocationButton: some View {
        UserLocationButton(
            trackingMode: $trackingMode,
            locationControl: $appState.locationControl,
            color: appTheme.color)
    }

    private var routeOverlayView: RouteOverlayView {
        RouteOverlayView(
            mapState: $mapState,
            appState: appState,
            color: appTheme.color)
    }

    private var editTagView: some View {
        EditTagView(tagProvider: mapState.self, onReset: onReset)
    }

    private func onReset() {
        mapState = .showingMap
        appState.showing.toggleButton = true
    }

    private var locationVisitsView: some View {
        LocationVisitsView(mapState: $mapState, showing: $appState.showing)
    }
}

private extension View {
    func modal(isPresented: Bool) -> some View {
        self
            .frame(width: screen.width, height: screen.height * 0.8)
            .offset(y: isPresented ? 0 : screen.height)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.3).extendToScreenEdges())
            .fade(if: !isPresented)
            .animation(.spring())
    }

    func blurBackground(if condition: Bool) -> some View {
        self
            .padding(.horizontal)
            .background(condition ?
                BlurView(style: .systemChromeMaterialDark)
                    .cornerRadius(20)
                    .blur(radius: 20)
                    .edgesIgnoringSafeArea(.top)
                : nil)
    }
}

struct AppMapView_Previews: PreviewProvider {
    static var previews: some View {
        AppMapView(appState: .init())
    }
}
