// Kevin Li - 5:50 PM - 5/16/20

import SwiftUI

struct LocationsForTagView: View {
    let tag: Tag
    let setActiveLocationAndDisplayMap: (Location) -> Void

    var locations: [Location] {
        Array(tag.locations)
    }

    var body: some View {
        Group {
            if locations.isEmpty {
                emptyLocationsView
            } else {
                filteredLocationsListView
            }
        }
    }

    private var emptyLocationsView: some View {
        VStack {
            Spacer()
            RadarSpinnerView(radarColor: tag.uiColor.color, radarOpacity: 0.75)
            Text("Add locations...")
                .font(.title)
            Spacer()
        }
    }

    private var filteredLocationsListView: FilteredLocationsListView {
        FilteredLocationsListView(
            locations: locations
                .sorted(by: { $0.name < $1.name }),
            setActiveLocationAndDisplayMap: setActiveLocationAndDisplayMap,
            color: tag.uiColor.color)
    }
}
