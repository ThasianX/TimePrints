// Kevin Li - 9:01 AM - 2/23/20

import SwiftUI

enum HomeFilter {
    case visits
    case tags
    case locations
}

struct VisitsHomeView: View {
    @State private var homeFilter: HomeFilter = .visits
    @State private var hideFAB: Bool = false

    @Binding var showingHomeView: Bool
    @Binding var activeVisitLocation: Location?

    var body: some View {
        ZStack {
            backgroundColor

            filterContent

            bottomRightAlignedExpandableFAB
                .padding(.trailing, 16)
                .padding(.bottom, 32)
                .fade(if: hideFAB)
        }
    }
}

private extension VisitsHomeView {
    private var backgroundColor: some View {
        ScreenColor(UIColor.black)
    }
}

private extension VisitsHomeView {
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

private extension VisitsHomeView {
    private var filterContent: AnyView {
        switch homeFilter {
        case .visits:
            return VisitsPreviewList(showingHomeView: $showingHomeView, activeVisitLocation: $activeVisitLocation, hideFAB: $hideFAB).erased()
        case .tags:
            return EmptyView().erased()
        case .locations:
            return EmptyView().erased()
        }
    }
}

struct VisitsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        VisitsHomeView(showingHomeView: .constant(true), activeVisitLocation: .constant(nil))
    }
}
