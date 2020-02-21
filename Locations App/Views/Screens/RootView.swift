import SwiftUI
import Mapbox

let screen = UIScreen.main.bounds
let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

struct RootView: View {
    @FetchRequest(entity: Location.entity(), sortDescriptors: []) var locations: FetchedResults<Location>
    
    @State private var trackingMode: MGLUserTrackingMode = .follow
    @State private var selectedLocation: Location?
    @State private var showingEditTag = false
    @State private var showingLocationVisits = false
    @State private var stayAtLocation = false
    @State private var showingVisitsPreviewList = false
    @State private var activeVisitLocation: Location? = nil

    var body: some View {
        ZStack(alignment: .bottom) {
            visitsPreviewList
                .fade(if: !showingVisitsPreviewList)
            
            annotatedMapView
                .fade(if: showingVisitsPreviewList)
            
            toggleViewButton
                .fade(if: showingEditTag || showingLocationVisits)
        }
    }
}

private extension RootView {
    private var visitsPreviewList: some View {
        VisitsPreviewList(showingVisitsPreviewList: $showingVisitsPreviewList, activeVisitLocation: $activeVisitLocation)
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
            UserLocationButton(trackingMode: $trackingMode, stayAtLocation: $stayAtLocation)
            Spacer()
        }
        .padding()
    }

    private var userLocationButton: some View {
        UserLocationButton(trackingMode: $trackingMode, stayAtLocation: $stayAtLocation)
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
            showingVisitsPreviewList.when(true: mapButtonBackgroundColor, false: listButtonBackgroundColor)
            BImage(perform: toggleVisitsPreviewAndStayAtLocation, image: showingVisitsPreviewList.when(true: mapImage, false: listImage))
                .foregroundColor(showingVisitsPreviewList.when(true: mapButtonColor, false: listButtonColor))
        }
        .frame(width: 50, height: 50)
        .clipShape(Circle())
    }

    private func toggleVisitsPreviewAndStayAtLocation() {
        showingVisitsPreviewList.toggle()
        stayAtLocation = true
    }

    private var mapImage: Image {
        .init(systemName: "map.fill")
    }
    
    private var listImage: Image {
        .init(systemName: "list.dash")
    }
    
    private var mapButtonColor: Color {
        .white
    }
    
    private var listButtonColor: Color {
        .black
    }
    
    private var mapButtonBackgroundColor: Color {
        .green
    }
    
    private var listButtonBackgroundColor: Color {
        .white
    }
}

struct RootView_Previews: PreviewProvider {
    
    static var previews: some View {
        RootView()
    }
    
}

