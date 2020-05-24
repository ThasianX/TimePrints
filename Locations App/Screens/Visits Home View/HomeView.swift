// Kevin Li - 9:01 AM - 2/23/20

import Mapbox
import SwiftUI

enum HomeFilter {
    case visits
    case tags
    case locations
}

struct HomeView: View {
    @State private var homeFilter: HomeFilter = .visits
    @State private var hideFAB: Bool = false

    @ObservedObject var appState: AppState

    var body: some View {
        ZStack {
            backgroundColor

            selectedContent

            bottomRightAlignedExpandableFAB
                .padding(.trailing, 16)
                .padding(.bottom, 32)
                .fade(if: hideFAB)
        }
    }
}

private extension HomeView {
    private var backgroundColor: some View {
        ScreenColor(UIColor.black)
    }
}

private extension HomeView {
    private var selectedContent: AnyView {
        switch homeFilter {
        case .visits:
            return VisitsPreviewList(
                hideFAB: $hideFAB,
                appState: appState).erased()
        case .tags:
            return
                TagsListView(
                    showing: appState.showing,
                    locationControl: appState.locationControl,
                    hideFAB: $hideFAB).erased()
        case .locations:
            return
                AllLocationsListView(
                    showing: appState.showing,
                    locationControl: appState.locationControl).erased()
        }
    }
}

private extension HomeView {
    private var bottomRightAlignedExpandableFAB: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                expandableFAB
            }
        }
    }

    private var expandableFAB: some View {
        ExpanadableFAB(menuInputs: menuInputs)
    }

    private var menuInputs: [ExpanadableFAB.MenuInput] {
        return [
            .init(action: setFilterToVisits, icon: "calendar", color: .blue, offsetY: -90),
            .init(action: setFilterToTags, icon: "tag.fill", color: .gray, offsetX: -60, offsetY: -60, delay: 0.1),
            .init(action: setFilterToLocations, icon: "globe", color: .red, offsetX: -90, delay: 0.2)
        ]
    }

    private func setFilterToVisits() {
        homeFilter = .visits
    }

    private func setFilterToTags() {
        homeFilter = .tags
    }

    private func setFilterToLocations() {
        homeFilter = .locations
    }
}

struct VisitsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(appState: .init())
    }
}
