import SwiftUI

private extension EditTagView {
    struct DeletedTag {
        let name: String
        let color: String

        var uiColor: UIColor {
            UIColor(color)
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
    
    @State private var showAdd: Bool = false
    @State private var showEdit: Bool = false
    @State private var nameInput: String = ""
    @State private var selectedColorIndex: Int = 1
    @State private var tagInEditing: Tag? = nil

    @State private var deletedTag: DeletedTag? = nil
    @State private var presentAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertItem: DispatchWorkItem = .init(block: {})
    @State private var locationsForDeletedTag: Set<Location> = .init()
    
    @Binding var show: Bool
    @Binding var location: Location?
    @Binding var stayAtLocation: Bool
    
    let colors = AppColors.tags
    let identifiers = AppColors.tags.ascendingKeys

    private var isShowingAddOrEdit: Bool {
        showAdd || showEdit
    }

    private var isntShowingAddNorEdit: Bool {
        !showAdd && !showEdit
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                header
                    .padding()
                    .offset(y: isShowingAddOrEdit ? 250 : 0)
                    .animation(.spring())
                
                tagSelectionList
                    .fade(if: isShowingAddOrEdit)
                    .scaleEffect(isShowingAddOrEdit ? 0 : 1)
                
                VSpace(50)
                    .fade(if: isShowingAddOrEdit)
            }
            
            topAlignedTagDetails
                .padding()
                .fade(if: isntShowingAddNorEdit)
                .scaleEffect(!isShowingAddOrEdit ? 0 : 1)
                .animation(.spring())
            
            bottomAlignedTransientAlertView
                .fade(if: !presentAlert)
        }
    }
}

private extension EditTagView {
    private var header: some View {
        HStack {
            editTagHeaderView
            Spacer()
            editTagHeaderButtons
        }
    }

    private var editTagHeaderView: some View {
        HStack {
            tagImage

            ZStack {
                headerText("CHOOSE TAG")
                    .fade(if: isShowingAddOrEdit)
                headerText("MAKE TAG")
                    .fade(if: !showAdd)
                headerText("EDIT TAG")
                    .fade(if: !showEdit)
            }
        }
        .animation(.easeInOut)
    }

    private var tagImage: some View {
        Image(systemName: "tag.fill")
            .foregroundColor(.white)
            .colorMultiply(isShowingAddOrEdit ? Color(selectedColor) : defaultTagColor)
    }

    private var defaultTagColor: Color {
        location != nil ? Color(location!.accent) : .clear
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
                .fade(if: isShowingAddOrEdit)
            HStack {
                xButton
                checkmarkButton
            }
            .fade(if: isntShowingAddNorEdit)
        }
        .animation(.easeInOut)
    }

    private var addButton: some View {
        BImage(condition: $showAdd, image: Image(systemName: "plus"))
            .foregroundColor(.white)
    }

    private var xButton: some View {
        BImage(perform: showAdd ? resetAddMode : resetEditMode, image: Image(systemName: "xmark.circle.fill"))
            .foregroundColor(.red)
    }

    private func resetAddMode() {
        resetNameAndColorInput()
        showAdd = false
    }

    private func resetEditMode() {
        tagInEditing = nil
        resetNameAndColorInput()
        showEdit = false
    }

    private var checkmarkButton: some View {
        BImage(perform: showAdd ? addNewTag : editTag, image: Image(systemName: "checkmark.circle.fill"))
            .foregroundColor(.white)
            .colorMultiply(Color(selectedColor))
    }

    private var selectedColor: UIColor {
        colors[identifiers[selectedColorIndex]]!
    }

    private func addNewTag() {
        let name = nameInput.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !name.isEmpty else {
            configureAlert(with: "Name cannot be empty")
            return
        }

        guard !Tag.containsTag(with: name, color: selectedColor) else {
            configureAlert(with: "Tag already exists")
            return
        }

        createTagAndExitView(name: name)
    }

    private func configureAlert(with message: String) {
        alertMessage = message
        presentAlert = true
        startTransientAlert()
    }

    private func createTagAndExitView(name: String) {
        let tag = Tag.create(name: name, color: selectedColor)
        setTagAndExitView(tag: tag)
        resetAddMode()
    }

    private func editTag() {
        let name = nameInput.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !name.isEmpty else {
            configureAlert(with: "Name cannot be empty")
            return
        }

        guard !Tag.containsTag(with: name, color: selectedColor) else {
            configureAlert(with: "Tag already exists")
            return
        }

        editTagAndExitEditMode(name: name)
    }

    private func editTagAndExitEditMode(name: String) {
        tagInEditing!.edit(name: name, color: selectedColor)
        resetEditMode()
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

    private func coloredTextRow(tag: Tag) -> ColoredTextRow {
        ColoredTextRow(text: tag.name, color: tag.uiColor, selected: self.location?.tag == tag)
    }

    private func contextMenu(for tag: Tag) -> some View {
        VStack {
            editButton(for: tag)
            deleteButton(for: tag)
        }
    }

    private func editButton(for tag: Tag) -> some View {
        Button(action: { self.displayEditTagAndSetState(tag: tag) }) {
            editTextPrecededByPencil
        }
    }

    private var editTextPrecededByPencil: some View {
        HStack {
            Text("Edit")
            Image(systemName: "pencil")
        }
    }

    private func displayEditTagAndSetState(tag: Tag) {
        tagInEditing = tag
        setEditModeState()
        showEdit = true
    }

    func setEditModeState() {
        nameInput = tagInEditing!.name
        let identifier = colors.key(for: tagInEditing!.uiColor)!
        selectedColorIndex = identifiers.firstIndex(of: identifier)!
    }

    private func deleteButton(for tag: Tag) -> some View {
        Button(action: { self.deleteTagAndDisplayAlert(tag: tag) }) {
            deleteTextPrecededByTrash
        }
    }

    private var deleteTextPrecededByTrash: some View {
        HStack {
            Text("Delete")
            Image(systemName: "trash.fill")
        }
    }

    private func deleteTagAndDisplayAlert(tag: Tag) {
        if tag.isDefault {
            self.alertMessage = "Default tag cannot be deleted"
        } else {
            storeLocationsAndDeleteTag(tag: tag)
        }
        self.presentAlert = true

        startTransientAlert()
    }

    private func storeLocationsAndDeleteTag(tag: Tag) {
        storeLocationsForDeletedTag(tag: tag)
        storeTagAndDeleteIt(tag: tag)
        setTagForAffectedLocationsToDefault()
    }

    private func storeLocationsForDeletedTag(tag: Tag) {
        locationsForDeletedTag = tag.locations
    }

    private func storeTagAndDeleteIt(tag: Tag) {
        setDeletedTag(tag: tag)
        tag.delete()
    }

    private func setDeletedTag(tag: Tag) {
        self.deletedTag = DeletedTag(name: tag.name, color: tag.color)
    }

    private func setTagForAffectedLocationsToDefault() {
        locationsForDeletedTag.forEach { $0.setTag(tag: .default) }
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
        TextField("Tag Name...", text: $nameInput)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .multilineTextAlignment(.center)
    }

    private var tagColorPicker: some View {
        Picker(selection: $selectedColorIndex, label: Text("")) {
            ForEach(0..<identifiers.count) { index in
                self.coloredTextRow(at: index)
            }
        }
        .labelsHidden()
    }

    private func coloredTextRow(at index: Int) -> ColoredTextRow {
        ColoredTextRow(text: identifiers[index], color: colors[self.identifiers[index]]!, selected: false, useStaticForegroundColor: true)
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
            if deletedTag != nil {
                deletedTagName
                    .padding(.trailing, 8)

                revertButton
            } else {
                alertMessageText
            }
        }
    }

    private var deletedTagName: some View {
        Text("Deleted: \(deletedTag!.name)")
            .font(.headline)
            .foregroundColor(.white)
            .animation(nil)
    }

    private var revertButton: some View {
        Button(action: revert) {
            revertText
        }
    }

    private var revertText: some View {
        Text("Revert")
            .font(.headline)
            .foregroundColor(Color(deletedTag!.uiColor))
            .animation(nil)
    }

    private func revert() {
        if let deletedTag = deletedTag {
            let tag = Tag.create(name: deletedTag.name, hex: deletedTag.color)
            revertTagForAffectedLocations(to: tag)
            resetAlert()
        }
    }

    private func revertTagForAffectedLocations(to tag: Tag) {
        locationsForDeletedTag.forEach { $0.setTag(tag: tag) }
    }

    private var alertMessageText: some View {
        Text(alertMessage)
            .foregroundColor(.white)
            .animation(nil)
    }
}

private extension EditTagView {
    private func resetNameAndColorInput() {
        nameInput = ""
        selectedColorIndex = 1
    }

    private func setTagAndExitView(tag: Tag) {
        location!.setTag(tag: tag)
        resetView()
    }

    private func resetView() {
        show = false
        stayAtLocation = true
        location = nil
        resetAlert()
    }

    private func startTransientAlert() {
        alertItem.cancel()
        alertItem = DispatchWorkItem { self.resetAlert() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: alertItem)
    }

    private func resetAlert() {
        self.presentAlert = false
        self.alertMessage = ""
        self.deletedTag = nil
    }
}

struct EditTagView_Previews: PreviewProvider {
    static var previews: some View {
        return EditTagView(show: .constant(true), location: .constant(.preview), stayAtLocation: .constant(false)).environment(\.managedObjectContext, CoreData.stack.context).background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
