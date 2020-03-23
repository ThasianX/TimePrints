import SwiftUI

class MapTagState: TagCoreState {
    func addNewTag(onAdd: (Tag) -> Void) {
        if isNameCompliable() {
            let newTag = operation.addNewTag()
            onAdd(newTag)
        }
    }
}

struct EditTagView: View {
    @FetchRequest(
        entity: Tag.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Tag.name, ascending: true)
        ]
    ) var tags: FetchedResults<Tag>

    @ObservedObject var tagState: MapTagState = .init()
    @State private var isAnimatingSelection: Bool = false

    let tagProvider: TagProvider
    let onReset: () -> Void

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                header
                    .padding()
                    .offset(y: tagState.isShowingAddOrEdit ? 250 : 0)
                    .animation(.spring())

                tagSelectionList
                    .fade(if: tagState.isShowingAddOrEdit)
                    .scaleEffect(tagState.isShowingAddOrEdit ? 0 : 1)

                VSpace(60)
                    .fade(if: tagState.isShowingAddOrEdit)
            }

            topAlignedTagOperationsView
                .padding()
                .fade(if: tagState.isntShowingAddNorEdit)
                .scaleEffect(!tagState.isShowingAddOrEdit ? 0 : 1)
                .animation(.spring())

            bottomAlignedTransientAlertView
                .fade(if: tagState.alert.isInactive)
        }
        .disabled(isAnimatingSelection)
    }
}

private extension EditTagView {
    private var header: some View {
        TagHeader(
            tagState: tagState,
            normalTagColor: tagProvider.normalTagColor,
            onSelect: setTagAndExitView)
    }

    private var tagSelectionList: some View {
        TagSelectionList(
            tagState: tagState,
            tags: Array(tags),
            onSelect: setTagAndExitView,
            selectedLocationTag: tagProvider.selectedLocation?.tag)
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

private extension EditTagView {
    private func setTagAndExitView(tag: Tag) {
        if tagProvider.selectedLocation!.tag == tag {
            resetView()
            return
        }
        
        tagProvider.selectedLocation!.setTag(tag: tag)
        isAnimatingSelection = true
        // 1.5 seconds is duration it takes for the checkmark lottie to finish
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.resetView()
        }
    }

    private func resetView() {
        onReset()
        isAnimatingSelection = false
        tagState.alert.stop()
    }
}

struct EditTagView_Previews: PreviewProvider {
    static var previews: some View {
        return EditTagView(tagProvider: MapState.showingEditTag(.preview), onReset: {}).environment(\.managedObjectContext, CoreData.stack.context).background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
