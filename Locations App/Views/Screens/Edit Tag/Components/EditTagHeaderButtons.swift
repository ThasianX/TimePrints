import SwiftUI

struct EditTagHeaderButtons: View {
    @Binding var showAdd: Bool
    
    let showEdit: Bool
    let resetAddTag: () -> Void
    let resetEditTag: () -> Void
    let addNewTag: () -> Void
    let editTag: () -> Void
    let selectedColor: Color
    
    var body: some View {
        ZStack {
            addButton
                .fade(isShowingAddOrEdit)
            HStack {
                xButton
                checkmarkButton
            }
            .fade(isntShowingAddNorEdit)
        }
        .animation(.easeInOut)
    }
}

private extension EditTagHeaderButtons {
    private var addButton: some View {
        BImage(condition: $showAdd, image: .init(systemName: "plus"))
            .foregroundColor(.white)
    }
    
    private var xButton: some View {
        BImage(perform: showAdd ? resetAddTag : resetEditTag, image: .init(systemName: "xmark.circle.fill"))
            .foregroundColor(.red)
    }
    
    private var checkmarkButton: some View {
        BImage(perform: showAdd ? addNewTag : editTag, image: .init(systemName: "checkmark.circle.fill"))
            .foregroundColor(.white)
            .colorMultiply(selectedColor)
    }
}

private extension EditTagHeaderButtons {
    private var isShowingAddOrEdit: Bool {
        showAdd || showEdit
    }
    
    private var isntShowingAddNorEdit: Bool {
        !showAdd && !showEdit
    }
}

struct EditTagHeaderButtons_Previews: PreviewProvider {
    static var previews: some View {
        EditTagHeaderButtons(showAdd: .constant(false), showEdit: false, resetAddTag: { }, resetEditTag: { }, addNewTag: { }, editTag: { }, selectedColor: Color(UIColor.salmon))
    }
}
