import SwiftUI
import Mapbox

let screen = UIScreen.main
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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VisitsPreviewList()
                .fade(!showingVisitsPreviewList)
                    
            ZStack(alignment: .top) {
                MapView(trackingMode: $trackingMode, selectedLocation: $selectedLocation, showingEditTag: $showingEditTag, showingLocationVisits: $showingLocationVisits, stayAtLocation: $stayAtLocation, annotations: locations.map(LocationAnnotation.init))
                    .extendToScreenEdges()
                    .disablur(showingEditTag || showingLocationVisits)

                HStack {
                    UserLocationButton(trackingMode: $trackingMode, stayAtLocation: $stayAtLocation)
                    Spacer()
                }
                .padding()
                .disablur(showingEditTag || showingLocationVisits)

                EditTagView(show: self.$showingEditTag, location: self.$selectedLocation, stayAtLocation: $stayAtLocation)
                    .frame(width: screen.bounds.width * 0.8, height: screen.bounds.height * 0.6)
                    .cornerRadius(30)
                    .shadow(radius: 20)
                    .fade(!showingEditTag)
                    .offset(y: showingEditTag ? screen.bounds.height * 0.15 : screen.bounds.height)
                    .animation(.spring())

                LocationVisitsView(show: $showingLocationVisits, selectedLocation: selectedLocation)
                    .frame(width: screen.bounds.width * 0.8, height: screen.bounds.height * 0.6)
                    .cornerRadius(30)
                    .shadow(radius: 20)
                    .fade(!showingLocationVisits)
                    .offset(y: showingLocationVisits ? screen.bounds.height * 0.15 : screen.bounds.height)
                    .animation(.spring())
            }
            .fade(showingVisitsPreviewList)
            
            toggleViewButton
                .fade(showingEditTag || showingLocationVisits)
        }
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

private extension RootView {
    private func toggleVisitsPreviewAndStayAtLocation() {
        showingVisitsPreviewList.toggle()
        stayAtLocation = true
    }
}

struct RootView_Previews: PreviewProvider {
    
    static var previews: some View {
        RootView()
    }
    
}

