// Kevin Li - 11:47 AM - 5/17/20

import SwiftUI

struct FilteredLocationsListView: View {
    @State private var query = ""
    @State private var showCancelButton = false

    let locations: [Location]

    var body: some View {
        filteredLocationsListView
    }

    private var filteredLocationsListView: some View {
        VStack {
            searchView
            filteredLocationsView
                .resignKeyboardOnDrag()
        }
    }
}

private extension FilteredLocationsListView {
    private var searchView: some View {
        HStack {
            HStack {
                magnifyingImage
                searchTextField
                resetFilterButton
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.gray)
            .background(Color.black)
            .cornerRadius(10.0)

            if showCancelButton {
                cancelSearchButton
            }
        }
        .padding(.horizontal)
    }

    private var magnifyingImage: some View {
        Image(systemName: "magnifyingglass")
    }

    private var searchTextField: some View {
        TextField("Search locations...", text: $query, onEditingChanged: filterLocations)
    }

    private func filterLocations(_ isEditing: Bool) {
        showCancelButton = true
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

    private var cancelSearchButton: some View {
        Button("Cancel") {
            self.cancelSearch()
        }
        .foregroundColor(Color(.systemBlue))
    }

    private func cancelSearch() {
        withAnimation {
            UIApplication.shared.endEditing(true)
            query = ""
            showCancelButton = false
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
        LocationRowView(location: location, locationService: CoreLocationService.shared)
    }
}
