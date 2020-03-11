import Mapbox
import SwiftUI

enum MapState: Equatable {
    case showingMap
    case showingEditTag(Location)
    case showingLocationVisits(Location)

    var isShowingMap: Bool {
        self == .showingMap
    }

    var isShowingEditTag: Bool {
        if case .showingEditTag(_) = self {
            return true
        }
        return false
    }

    var isshowingLocationVisits: Bool {
        if case .showingLocationVisits(_) = self {
            return true
        }
        return false
    }

    var hasSelectedLocation: Bool {
        switch self {
        case .showingEditTag, .showingLocationVisits:
            return true
        case .showingMap:
            return false
        }
    }

    var selectedLocation: Location {
        switch self {
        case let .showingEditTag(location), let .showingLocationVisits(location):
            return location
        case .showingMap:
            fatalError("Should not be calling `selectedLocation` when the map is showing")
        }
    }
}

private extension View {
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

struct AppMapView: View {
    @Environment(\.appTheme) private var appTheme: UIColor
    @FetchRequest(entity: Location.entity(), sortDescriptors: []) var locations: FetchedResults<Location>

    @State private var trackingMode: MGLUserTrackingMode = .follow
    @State private var mapState: MapState = .showingMap

    @Binding var showingToggleButton: Bool
    @Binding var stayAtLocation: Bool
    @Binding var activeVisitLocation: Location?
    @ObservedObject var activeRoute: ActiveRoute

    var body: some View {
        ZStack(alignment: .top) {
            Group {
                mapViewWithCenterPointer
                    .extendToScreenEdges()
                buttonHeader
                    .blurBackground(if: activeRoute.exists)
            }
            .disablur(!mapState.isShowingMap)

            editTagView
                .modal(isPresented: mapState.isShowingEditTag)

            locationVisitsView
                .modal(isPresented: mapState.isshowingLocationVisits)
        }
    }

    private var mapViewWithCenterPointer: some View {
        ZStack {
            mapView
            if activeRoute.exists {
                mapViewCenterIndicator
                    .offset(y: 20)
            }
        }
    }

    private var mapView: some View {
        MapView(
            mapState: $mapState,
            trackingMode: $trackingMode,
            showingToggleButton: $showingToggleButton,
            stayAtLocation: $stayAtLocation,
            activeVisitLocation: $activeVisitLocation,
            activeRoute: activeRoute,
            userLocationColor: appTheme,
            annotations: locations.map(LocationAnnotation.init)
        )
    }

    private var mapViewCenterIndicator: some View {
        CenterIndicator(color: appTheme.color)
    }

    struct CenterIndicator: View {
        @State var show = false

        let color: Color

        var body: some View {
            Image(systemName: "triangle.fill")
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(color)
                .scaleEffect(show ? 1 : 0.5)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                .onAppear(perform: makeVisible)
        }

        private func makeVisible() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.show = true
            }
        }
    }

    private var buttonHeader: some View {
        ZStack {
            HStack {
                userLocationButton
                Spacer()
            }
            .padding()
            .fade(if: activeRoute.exists)

            HStack {
                closeRouteButton
                Spacer()
                nextLocationButton
            }
            .padding()
            .fade(if: !activeRoute.exists)
        }
    }

    private var userLocationButton: some View {
        UserLocationButton(
            trackingMode: $trackingMode,
            stayAtLocation: $stayAtLocation,
            activeVisitLocation: $activeVisitLocation,
            color: appTheme.color)
    }

    private var closeRouteButton: some View {
        CloseRouteButton(
            activeRoute: activeRoute,
            stayAtLocation: $stayAtLocation)
    }

    private var nextLocationButton: some View {
        NextLocationButton(
            activeRoute: activeRoute,
            stayAtLocation: $stayAtLocation,
            color: appTheme.color)
    }

    private var editTagView: some View {
        EditTagView(
            mapState: $mapState,
            stayAtLocation: $stayAtLocation,
            showingToggleButton: $showingToggleButton)
    }

    private var locationVisitsView: some View {
        LocationVisitsView(
            mapState: $mapState,
            showingToggleButton: $showingToggleButton)
    }
}

private extension View {
    func modal(isPresented: Bool) -> some View {
        self
            .frame(width: screen.width, height: screen.height * 0.8)
            .cornerRadius(30)
            .shadow(radius: 20)
            .fade(if: !isPresented)
            .offset(y: isPresented ? screen.height * 0.1 : screen.height)
            .animation(.spring())
    }
}

struct AppMapView_Previews: PreviewProvider {
    static var previews: some View {
        AppMapView(showingToggleButton: .constant(true), stayAtLocation: .constant(false), activeVisitLocation: .constant(nil), activeRoute: .init())
    }
}
