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
    @Binding var mapState: MapState
    @Binding var showing: AppState.Showing

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

            topAlignedTagDetails
                .padding()
                .fade(if: tagState.isntShowingAddNorEdit)
                .scaleEffect(!tagState.isShowingAddOrEdit ? 0 : 1)
                .animation(.spring())

            bottomAlignedTransientAlertView
                .fade(if: !tagState.alert.isInactive)
        }
        .disabled(isAnimatingSelection)
    }
}

private extension EditTagView {
    private var header: some View {
        HStack {
            editTagHeaderView
            Spacer()
            editTagHeaderButtons
        }
        .padding(.horizontal)
    }

    private var editTagHeaderView: some View {
        HStack {
            tagImage

            ZStack {
                headerText("CHOOSE TAG")
                    .fade(if: tagState.isShowingAddOrEdit)
                headerText("MAKE TAG")
                    .fade(if: !tagState.operation.add)
                headerText("EDIT TAG")
                    .fade(if: !tagState.operation.edit)
            }
        }
        .animation(.easeInOut)
    }

    private var tagImage: some View {
        Image(systemName: "tag.fill")
            .foregroundColor(.white)
            .colorMultiply(tagState.isShowingAddOrEdit ? tagState.operation.selectedColor.color : defaultTagColor)
    }

    private var defaultTagColor: Color {
        mapState.hasSelectedLocation ? Color(mapState.selectedLocation.accent) : Color.clear
    }

    private func headerText(_ text: String) -> some View {
        Text(text)
            .tracking(5)
            .font(.system(size: 20))
            .bold()
            .foregroundColor(.white)
    }

    private var editTagHeaderButtons: some View {
        ZStack {
            addButton
                .fade(if: tagState.isShowingAddOrEdit)
            HStack(spacing: 16) {
                xButton
                checkmarkButton
            }
            .fade(if: tagState.isntShowingAddNorEdit)
        }
        .animation(.easeInOut)
    }

    private var addButton: some View {
        BImage(perform: tagState.operation.beginAdd, image: Image(systemName: "plus"))
            .foregroundColor(.white)
    }

    private var xButton: some View {
        BImage(perform: onExit, image: Image(systemName: "xmark.circle.fill"))
            .foregroundColor(.red)
    }

    private func onExit() {
        if tagState.operation.add {
            tagState.operation.resetAdd()
        } else {
            tagState.operation.resetEdit()
        }
    }

    private var checkmarkButton: some View {
        BImage(perform: onCommit, image: Image(systemName: "checkmark.circle.fill"))
            .foregroundColor(.white)
            .colorMultiply(tagState.operation.selectedColor.color)
    }

    private func onCommit() {
        if tagState.operation.add {
            tagState.addNewTag(onAdd: setTagAndExitView)
        } else {
            tagState.editTag()
        }
    }
}

private extension EditTagView {
    private var tagSelectionList: some View {
        VScroll {
            tagSelectionStack
        }
    }

    private var tagSelectionStack: some View {
        VStack {
            ForEach(tags) { tag in
                self.interactiveColoredTextRow(tag: tag)
                    .padding(.horizontal)
                    .id(tag.name)
                    .id(tag.color)
            }
        }
    }

    private func interactiveColoredTextRow(tag: Tag) -> some View {
        coloredTextRow(tag: tag)
            .onTapGesture {
                self.setTagAndExitView(tag: tag)
            }
            .contextMenu {
                self.contextMenu(for: tag)
            }
    }

    private func coloredTextRow(tag: Tag) -> TagRow {
        let isSelected = mapState.hasSelectedLocation ? mapState.selectedLocation.tag == tag : false
        return TagRow(tag: tag, isSelected: isSelected)
    }

    private func contextMenu(for tag: Tag) -> some View {
        VStack {
            editButton(for: tag)
            deleteButton(for: tag)
        }
    }

    private func editButton(for tag: Tag) -> some View {
        Button(action: { self.tagState.operation.setTagToEdit(tag) }) {
            editTextPrecededByPencil
        }
    }

    private var editTextPrecededByPencil: some View {
        HStack {
            Text("Edit")
            Image(systemName: "pencil")
        }
    }

    private func deleteButton(for tag: Tag) -> some View {
        Button(action: { self.tagState.removeTag(tag) }) {
            deleteTextPrecededByTrash
        }
    }

    private var deleteTextPrecededByTrash: some View {
        HStack {
            Text("Delete")
            Image(systemName: "trash.fill")
        }
    }
}

private extension EditTagView {
    private var topAlignedTagDetails: some View {
        VStack {
            tagDetailsView
            Spacer()
        }
    }

    private var tagDetailsView: some View {
        VStack {
            tagNameTextField
                .padding(.init(top: 0, leading: 30, bottom: 0, trailing: 30))

            tagColorPicker
        }
    }

    private var tagNameTextField: some View {
        let nameInput = Binding(
            get: { self.tagState.operation.nameInput },
            set: { self.tagState.operation.nameInput = $0 })

        return TextField("Tag Name...", text: nameInput)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .multilineTextAlignment(.center)
    }

    private var tagColorPicker: some View {
        let selectedColorIndex = Binding(
            get: { self.tagState.operation.selectedColorIndex },
            set: { self.tagState.operation.selectedColorIndex = $0 })

        return Picker(selection: selectedColorIndex, label: Text("")) {
            ForEach(0..<AppColors.identifiers.count) { index in
                self.coloredTextRow(at: index)
                    .tag(index)
            }
        }
        .labelsHidden()
    }

    private func coloredTextRow(at index: Int) -> ColoredTextRow {
        ColoredTextRow(text: AppColors.identifiers[index], color: AppColors.tags[AppColors.identifiers[index]]!, selected: false, useStaticForegroundColor: true)
    }
}

private extension EditTagView {
    private var bottomAlignedTransientAlertView: some View {
        VStack {
            Spacer()
            transientAlertView
                .padding()
        }
    }

    private var transientAlertView: some View {
        HStack {
            deletedTagMessageDefaultsAlertMessage
        }
    }

    private var deletedTagMessageDefaultsAlertMessage: some View {
        Group {
            if tagState.alert.isRemoval {
                deletedTagName
                    .padding(.trailing, 8)

                revertButton
                    .padding(8)
                    .background(tagState.alert.deletedTag.uiColor.color)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            } else {
                alertMessageText
            }
        }
    }

    private var deletedTagName: some View {
        Text("Deleted: \(tagState.alert.deletedTag.name)")
            .font(.system(size: 20))
            .foregroundColor(.white)
            .animation(nil)
    }

    private var revertButton: some View {
        Button(action: tagState.revertDeletion) {
            Text("Revert")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .animation(nil)
        }
    }

    private var alertMessageText: some View {
        Text(tagState.alert.message)
            .foregroundColor(.white)
            .animation(nil)
    }
}

private extension EditTagView {
    private func setTagAndExitView(tag: Tag) {
        if mapState.selectedLocation.tag == tag {
            resetView()
            return
        }
        
        mapState.selectedLocation.setTag(tag: tag)
        isAnimatingSelection = true
        // 1.5 seconds is duration it takes for the checkmark lottie to finish
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.resetView()
        }
    }

    private func resetView() {
        mapState = .showingMap
        showing.toggleButton = true
        isAnimatingSelection = false
        tagState.alert.stop()
    }
}

struct EditTagView_Previews: PreviewProvider {
    static var previews: some View {
        return EditTagView(mapState: .constant(.showingEditTag(.preview)), showing: .constant(.init())).environment(\.managedObjectContext, CoreData.stack.context).background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
