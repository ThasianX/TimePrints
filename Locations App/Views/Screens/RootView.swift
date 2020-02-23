import SwiftUI
import Mapbox

let screen = UIScreen.main.bounds
let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

struct RootView: View {
    @FetchRequest(entity: Location.entity(), sortDescriptors: []) var locations: FetchedResults<Location>

    @State private var showingEditTag = false
    @State private var showingLocationVisits = false
    @State private var stayAtLocation = false
    @State private var showingHomeView = false

    @State private var trackingMode: MGLUserTrackingMode = .follow
    @State private var selectedLocation: Location? = nil
    @State private var activeVisitLocation: Location? = nil

    var body: some View {
        ZStack(alignment: .bottom) {
            visitsHomeView
                .fade(if: !showingHomeView)
            
            annotatedMapView
                .fade(if: showingHomeView)
            
            toggleViewButton
                .fade(if: showingEditTag || showingLocationVisits)
        }
    }
}

private extension RootView {
    private var visitsHomeView: some View {
        VisitsHomeView(showingHomeView: $showingHomeView, activeVisitLocation: $activeVisitLocation)
    }
}

private extension View {
    func modal(isPresented: Bool) -> some View {
        self
            .frame(width: screen.width * 0.8, height: screen.height * 0.6)
            .cornerRadius(30)
            .shadow(radius: 20)
            .fade(if: !isPresented)
            .offset(y: isPresented ? screen.height * 0.15 : screen.height)
            .animation(.spring())
    }
}

private extension RootView {
    private var annotatedMapView: some View {
        ZStack(alignment: .top) {
            mapView
                .extendToScreenEdges()
                .disablur(showingEditTag || showingLocationVisits)

            buttonHeader
                .disablur(showingEditTag || showingLocationVisits)

            editTagView
                .modal(isPresented: showingEditTag)

            locationVisitsView
                .modal(isPresented: showingLocationVisits)
        }
    }

    private var mapView: some View {
        MapView(
            trackingMode: $trackingMode,
            selectedLocation: $selectedLocation,
            showingEditTag: $showingEditTag,
            showingLocationVisits: $showingLocationVisits,
            stayAtLocation: $stayAtLocation,
            activeVisitLocation: $activeVisitLocation,
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
            stayAtLocation: $stayAtLocation,
            activeVisitLocation: $activeVisitLocation
        )
    }

    private var editTagView: some View {
        EditTagView(
            show: self.$showingEditTag,
            location: self.$selectedLocation,
            stayAtLocation: $stayAtLocation
        )
    }

    private var locationVisitsView: some View {
        LocationVisitsView(
            show: $showingLocationVisits,
            selectedLocation: selectedLocation
        )
    }
}

private extension RootView {
    private var toggleViewButton: some View {
        ZStack {
            toggleBackgroundColor
            BImage(perform: toggleVisitsPreviewAndStayAtLocation, image: toggleImage)
                .foregroundColor(toggleForegroundColor)
        }
        .frame(width: 50, height: 50)
        .clipShape(Circle())
    }

    private var toggleBackgroundColor: Color {
        showingHomeView ? .green : .white
    }

    private func toggleVisitsPreviewAndStayAtLocation() {
        activeVisitLocation = nil
        showingHomeView.toggle()
        stayAtLocation = true
    }

    private var toggleImage: Image {
        showingHomeView ? Image(systemName: "map.fill") : Image(systemName: "list.dash")
    }

    private var toggleForegroundColor: Color {
        showingHomeView ? .white : .black
    }
}

struct RootView_Previews: PreviewProvider {
    
    static var previews: some View {
        RootView()
    }
    
}

