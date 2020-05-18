// Kevin Li - 5:50 PM - 5/16/20

import SwiftUI

struct LocationsForTagView: View {
    let tag: Tag
    let setActiveLocationAndDisplayMap: (Location) -> Void

    var body: some View {
        FilteredLocationsListView(
            locations: Array(tag.locations)
                .sorted(by: { $0.name < $1.name }),
            setActiveLocationAndDisplayMap: setActiveLocationAndDisplayMap,
            color: tag.uiColor.color)
    }
}
