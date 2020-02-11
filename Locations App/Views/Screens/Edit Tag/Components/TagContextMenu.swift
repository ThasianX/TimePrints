import SwiftUI

struct TagContextMenu: View {
    let tag: Tag
    let onEdit: (Tag) -> Void
    let onDelete: (Tag) -> Void
    
    var body: some View {
        VStack {
            editButton
            deleteButton
        }
    }
}

private extension TagContextMenu {
    private var editButton: some View {
        Button(action: { self.onEdit(self.tag) }) {
            HStack {
                Text("Edit")
                Image(systemName: "pencil")
            }
        }
    }
    
    private var deleteButton: some View {
        Button(action: { self.onDelete(self.tag)}) {
            HStack {
                Text("Delete")
                Image(systemName: "trash.fill")
            }
        }
    }
}

struct TagContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        TagContextMenu(tag: .preview, onEdit: { _ in }, onDelete: { _ in })
    }
}
