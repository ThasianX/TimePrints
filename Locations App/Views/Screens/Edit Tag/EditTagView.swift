import SwiftUI

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
    @State private var presentAlert: Bool = false
    @State private var deletedTag: Tag? = nil
    @State private var alertMessage: String = ""
    
    @Binding var show: Bool
    @Binding var location: Location?
    @Binding var stayAtLocation: Bool
    
    let colors = AppColors.tags
    let identifiers = AppColors.tags.ascendingKeys
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                header
                    .padding()
                    .offset(y: isShowingAddOrEdit.when(true: 250, false: 0))
                    .animation(.spring())
                
                tagSelectionList
                    .fade(isShowingAddOrEdit)
                    .scaleEffect(isShowingAddOrEdit.when(true: 0, false: 1))
                
                VSpace(50)
                    .fade(isShowingAddOrEdit)
            }
            
            tagDetails
                .padding()
                .fade(isntShowingAddNorEdit)
                .scaleEffect(isShowingAddOrEdit.when(true: 1, false: 0))
                .animation(.spring())
            
            transientAlert
                .fade(!presentAlert)
        }
    }
}

private extension EditTagView {
    private var header: some View {
        HStack {
            EditTagHeaderText(showAdd: showAdd, showEdit: showEdit, selectedColor: selectedColor, location: location)
            
            Spacer()
            
            EditTagHeaderButtons(showAdd: $showAdd, showEdit: showEdit, resetAddTag: resetAddTag, resetEditTag: resetEditTag, addNewTag: addNewTag, editTag: editTag, selectedColor: selectedColor)
        }
    }
    
    private var tagSelectionList: some View {
        TagSelectionList(tags: Array(tags), location: location, onTap: setTag, onEdit: displayEditTag, onDelete: deleteTag)
    }
    
    private var tagDetails: some View {
        VStack {
            TagDetails(nameInput: $nameInput, selectedColorIndex: $selectedColorIndex, colors: colors, colorNames: identifiers)
            Spacer()
        }
    }
    
    private var transientAlert: some View {
        VStack {
            Spacer()
            TransientAlert(deletedTag: deletedTag, alertMessage: alertMessage, revert: revert)
        }
    }
}

private extension EditTagView {
    private var selectedColor: Color {
        Color(colors[identifiers[selectedColorIndex]]!)
    }
    
    private var isShowingAddOrEdit: Bool {
        showAdd || showEdit
    }
    
    private var isntShowingAddNorEdit: Bool {
        !showAdd && !showEdit
    }
}

private extension EditTagView {
    private func reset() {
        resetAddTag()
        show = false
        stayAtLocation = true
        location = nil
    }
    
    private func resetAddTag() {
        nameInput = ""
        selectedColorIndex = 1
        showAdd = false
    }
    
    private func resetAlert() {
        self.presentAlert = false
        self.alertMessage = ""
        self.deletedTag = nil
    }
    
    private func resetEditTag() {
        tagInEditing = nil
        nameInput = ""
        selectedColorIndex = 1
        showEdit = false
    }
    
    private func addNewTag() {
        let name = nameInput.trimmingCharacters(in: .whitespacesAndNewlines)
        if !name.isEmpty {
            let tag = Tag.create(name: nameInput, color: colors[identifiers[selectedColorIndex]]!)
            location!.setTag(tag: tag)
            reset()
        }
    }
    
    private func setTag(tag: Tag) {
        location!.setTag(tag: tag)
        reset()
    }
    
    private func displayEditTag(tag: Tag) {
        tagInEditing = tag
        nameInput = tag.name
        let identifier = colors.key(for: tag.uiColor)!
        selectedColorIndex = identifiers.firstIndex(of: identifier)!
        showEdit = true
    }
    
    private func deleteTag(tag: Tag) {
        guard let location = location else { return }
        let defaultTag = Tag.getDefault()
        if tag == defaultTag {
            self.alertMessage = "Cannot delete default tag"
        } else {
            let deleted = tag.delete()
            if deleted == location.tag {
                location.setTag(tag: defaultTag)
            }
            self.deletedTag = tag
        }
        self.presentAlert = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.resetAlert()
        }
    }
    
    private func editTag() {
        let name = nameInput.trimmingCharacters(in: .whitespacesAndNewlines)
        if !name.isEmpty {
            tagInEditing!.edit(name: nameInput, color: colors[identifiers[selectedColorIndex]]!)
            resetEditTag()
        }
    }
    
    private func revert() {
        if let tag = deletedTag {
            Tag.create(from: tag)
            resetAlert()
        }
    }
}

struct EditTagView_Previews: PreviewProvider {
    static var previews: some View {
        return EditTagView(show: .constant(true), location: .constant(.preview), stayAtLocation: .constant(false)).environment(\.managedObjectContext, CoreData.stack.context).background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
