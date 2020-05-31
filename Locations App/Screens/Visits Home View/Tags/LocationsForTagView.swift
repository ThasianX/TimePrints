// Kevin Li - 5:50 PM - 5/16/20

import SwiftUI

struct LocationsForTagView: View {
    let tag: Tag
    let setActiveLocationAndDisplayMap: (Location) -> Void

    var body: some View {
        Group {
            if tag.locations.isEmpty {
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

    private var filteredLocationsListView: some View {
        FilteredListView(
            sortDescriptors: [locationNameSort],
            predicate: locationsPredicate,
            searchKey: "name",
            placeholder: "Search locations...",
            searchColor: tag.uiColor.color,
            content: locationRowView)
    }

    private var locationNameSort: NSSortDescriptor {
        NSSortDescriptor(keyPath: \Location.name, ascending: true)
    }

    private var locationsPredicate: NSPredicate {
        NSPredicate(format: "%@ == tag", tag)
    }

    private func locationRowView(for location: Location) -> LocationRowView {
        LocationRowView(
            location: location,
            locationService: CoreLocationService.shared,
            setActiveLocationAndDisplayMap: setActiveLocationAndDisplayMap)
    }
}
