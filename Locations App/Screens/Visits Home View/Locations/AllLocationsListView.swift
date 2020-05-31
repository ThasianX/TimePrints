// Kevin Li - 4:25 PM - 2/23/20

import SwiftUI

struct AllLocationsListView: View {
    @Environment(\.appTheme) private var appTheme: UIColor

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

    private var filteredLocationsListView: some View {
        FilteredSearchView(
            sortDescriptors: [locationNameSort],
            searchKey: "name",
            placeholder: "Search locations...",
            searchColor: appTheme.color,
            content: locationRowView)
    }

    var locationNameSort: NSSortDescriptor {
        NSSortDescriptor(keyPath: \Location.name, ascending: true)
    }

    private func locationRowView(for location: Location) -> LocationRowView {
        LocationRowView(
            location: location,
            locationService: CoreLocationService.shared,
            setActiveLocationAndDisplayMap: setActiveLocationAndDisplayMap)
    }

    private func setActiveLocationAndDisplayMap(location: Location) {
        locationControl.currentlyFocused = location
        showMapView()
    }

    private func showMapView() {
        showing.homeView = false
    }
}
