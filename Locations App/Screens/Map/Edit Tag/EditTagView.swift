import SwiftUI

class AddNewTagState: TagCoreState {
    func addNewTag(onAdd: (Tag) -> Void) {
        UIApplication.shared.endEditing(true)
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

    @ObservedObject var tagState: AddNewTagState = .init()
    @State private var isAnimatingSelection: Bool = false

    let tagProvider: TagProvider
    let onReset: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            header
                .padding()
                .offset(y: tagState.isShowingAddOrEdit ? 250 : 0)

            tagSelectionList
                .padding(.bottom, 125)
                .offset(y: 60)
                .scaleFade(if: tagState.isShowingAddOrEdit)

            topAlignedTagOperationsView
                .padding()
                .scaleFade(if: tagState.isntShowingAddNorEdit)

            bottomAlignedTransientAlertView
                .fade(if: tagState.alert.isInactive)
        }
        .animation(.spring())
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

        // This line is necessary because it's possible to tap on the closing modal view which will cause an error
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.isAnimatingSelection = false
        }
    }

    private func resetView() {
        onReset()
        tagState.alert.stop()
    }
}

struct EditTagView_Previews: PreviewProvider {
    static var previews: some View {
        return EditTagView(tagProvider: MapState.showingEditTag(.preview), onReset: {}).environment(\.managedObjectContext, CoreData.stack.context).background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
