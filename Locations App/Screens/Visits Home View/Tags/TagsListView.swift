// Kevin Li - 1:27 PM - 2/23/20

import SwiftUI

struct TagsListView: View {
    @FetchRequest(
        entity: Tag.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Tag.name, ascending: true)
        ]
    ) var tags: FetchedResults<Tag>

    @ObservedObject var tagState: TagCoreState = .init()

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                header
                    .padding()
                    .offset(y: tagState.isShowingAddOrEdit ? 250 : 0)
                    .animation(.spring())

                tagSelectionList
                    .fade(if: tagState.isShowingAddOrEdit)
                    .scaleEffect(tagState.isShowingAddOrEdit ? 0.1 : 1)

                VSpace(60)
                    .fade(if: tagState.isShowingAddOrEdit)
            }

            topAlignedTagOperationsView
                .padding()
                .fade(if: tagState.isntShowingAddNorEdit)
                .scaleEffect(!tagState.isShowingAddOrEdit ? 0.1 : 1)
                .animation(.spring())

            bottomAlignedTransientAlertView
                .fade(if: tagState.alert.isInactive)
        }
        .animation(.spring())
    }

}

private extension TagsListView {
    private var header: some View {
        TagHeader(
            tagState: tagState,
            normalTagColor: .clear)
    }

    private var tagSelectionList: some View {
        TagSelectionList(
            tagState: tagState,
            tags: Array(tags),
            onSelect: { _ in })
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
        TagsListView()
    }
}
