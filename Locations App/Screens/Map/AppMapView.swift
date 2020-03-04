import Mapbox
import SwiftUI

struct AppMapView: View {
    @FetchRequest(entity: Location.entity(), sortDescriptors: []) var locations: FetchedResults<Location>

    @State private var trackingMode: MGLUserTrackingMode = .follow
    @State private var showingEditTag = false
    @State private var showingLocationVisits = false
    @State private var selectedLocation: Location? = nil

    @Binding var showingToggleButton: Bool
    @Binding var stayAtLocation: Bool
    @Binding var activeVisitLocation: Location?

    var body: some View {
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
            showingToggleButton: $showingToggleButton,
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
            show: $showingEditTag,
            location: $selectedLocation,
            stayAtLocation: $stayAtLocation,
            showingToggleButton: $showingToggleButton
        )
    }

    private var locationVisitsView: some View {
        LocationVisitsView(
            show: $showingLocationVisits,
            showingToggleButton: $showingToggleButton,
            selectedLocation: selectedLocation
        )
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
        AppMapView(showingToggleButton: .constant(true), stayAtLocation: .constant(false), activeVisitLocation: .constant(nil))
    }
}
