// Kevin Li - 1:27 PM - 2/23/20

import SwiftUI

struct TagsListView: View {
    @Environment(\.appTheme) private var appTheme: UIColor

    @FetchRequest(
        entity: Tag.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Tag.name, ascending: true)
        ]
    ) var tags: FetchedResults<Tag>

    @ObservedObject var tagState: TagCoreState = .init()
    @State private var selectedTag: Tag? = nil

    @ObservedObject var showing: AppState.Showing
    @ObservedObject var locationControl: AppState.LocationControl
    @Binding var hideFAB: Bool

    private var isShowingTag: Bool {
        selectedTag != nil
    }

    var body: some View {
        ZStack(alignment: .top) {
            header
                .padding()
                .offset(y: tagState.isShowingAddOrEdit ? 250 : 0)
                .scaleFade(if: isShowingTag)

            tagPreviewList
                .padding(.bottom, isShowingTag ? 0 : 225)
                .offset(y: isShowingTag ? 0 : 60)
                .scaleFade(if: tagState.isShowingAddOrEdit)

            topAlignedTagOperationsView
                .padding()
                .scaleFade(if: tagState.isntShowingAddNorEdit || isShowingTag)

            bottomAlignedTransientAlertView
                .padding(.bottom, 100)
                .fade(if: tagState.alert.isInactive || isShowingTag)
        }
        .animation(.spring())
    }
}

private extension TagsListView {
    private var header: some View {
        TagHeader(
            tagState: tagState,
            normalTagColor: appTheme.color)
    }

    private var tagPreviewList: some View {
        TagPreviewList(tagState: tagState,
                       selectedTag: $selectedTag,
                       hideFAB: $hideFAB,
                       tags: Array(tags),
                       setActiveLocationAndDisplayMap: setActiveLocationAndDisplayMap)
    }

    private func toggleNavigationButton() {
        hideFAB.toggle()
    }

    private func setActiveLocationAndDisplayMap(location: Location) {
        locationControl.currentlyFocused = location
        showMapView()
    }

    private func showMapView() {
        showing.homeView = false
    }

    private var topAlignedTagOperationsView: some View {
        VStack {
            TagOperationsView(tagState: tagState)
            Spacer()
        }
    }

    private var bottomAlignedTransientAlertView: some View {
        VStack {
            Spacer()
            TransientAlertView(tagState: tagState)
                .padding()
        }
    }
}

struct TagsListView_Previews: PreviewProvider {
    static var previews: some View {
        TagsListView(showing: .init(), locationControl: .init(), hideFAB: .constant(true))
    }
}
