// Kevin Li - 4:25 PM - 2/23/20

import SwiftUI

struct AllLocationsListView: View {
    @Environment(\.appTheme) private var appTheme: UIColor
    @FetchRequest(
        entity: Location.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Location.name, ascending: true)
        ]
    ) private var locations: FetchedResults<Location>

    @ObservedObject var showing: AppState.Showing
    @ObservedObject var locationControl: AppState.LocationControl

    var body: some View {
        V0Stack {
            leftAlignedHeader
            filteredLocationsListView
        }
    }
}

private extension AllLocationsListView {
    private var leftAlignedHeader: some View {
        HStack {
            headerText
                .padding(.leading)
            Spacer()
        }
        .padding()
    }

    private var headerText: some View {
        Text("Locations")
            .font(.largeTitle)
            .foregroundColor(appTheme.color)
    }

    private var filteredLocationsListView: FilteredLocationsListView {
        FilteredLocationsListView(
            locations: Array(locations),
            setActiveLocationAndDisplayMap: setActiveLocationAndDisplayMap,
            color: appTheme.color)
    }

    private func setActiveLocationAndDisplayMap(location: Location) {
        locationControl.currentlyFocused = location
        showMapView()
    }

    private func showMapView() {
        showing.homeView = false
    }
}
