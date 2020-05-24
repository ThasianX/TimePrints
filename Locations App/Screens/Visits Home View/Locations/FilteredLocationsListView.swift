// Kevin Li - 11:47 AM - 5/17/20

import SwiftUI

struct FilteredLocationsListView: View {
    @State private var query = ""

    let locations: [Location]
    let setActiveLocationAndDisplayMap: (Location) -> Void
    let color: Color

    var body: some View {
        filteredLocationsListView
    }

    private var filteredLocationsListView: some View {
        VStack {
            searchView
            filteredLocationsView
                .resignKeyboardOnDrag()
                .padding(.bottom, 25)
        }
    }
}

private extension FilteredLocationsListView {
    private var searchView: some View {
        HStack {
            magnifyingImage
            searchTextField
            resetFilterButton
        }
        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
        .foregroundColor(.gray)
        .background(color.saturation(0.5))
        .cornerRadius(10.0)
        .padding(.horizontal)
    }

    private var magnifyingImage: some View {
        Image(systemName: "magnifyingglass")
    }

    private var searchTextField: some View {
        TextField("Search locations...", text: $query)
    }

    private var resetFilterButton: some View {
        Button(action: {
            self.resetFilter()
        }) {
            Image(systemName: "xmark.circle.fill")
                .opacity(query == "" ? 0 : 1)
        }
    }

    private func resetFilter() {
        withAnimation {
            query = ""
        }
    }
}

private extension FilteredLocationsListView {
    private var filteredLocationsView: some View {
        List {
            ForEach(locations.filter { $0.name.hasPrefix(query) || query == "" }) { location in
                self.locationRowView(for: location)
            }
        }
    }

    private func locationRowView(for location: Location) -> LocationRowView {
        LocationRowView(
            location: location,
            locationService: CoreLocationService.shared,
            setActiveLocationAndDisplayMap: setActiveLocationAndDisplayMap)
    }
}
