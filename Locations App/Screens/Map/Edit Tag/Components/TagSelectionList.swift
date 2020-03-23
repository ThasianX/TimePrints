import SwiftUI

struct TagSelectionList: View {
    @ObservedObject var tagState: TagCoreState

    let tags: [Tag]
    let onSelect: (Tag) -> Void
    let selectedLocationTag: Tag?

    var body: some View {
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
                self.onSelect(tag)
            }
            .contextMenu {
                self.contextMenu(for: tag)
            }
    }

    private func coloredTextRow(tag: Tag) -> TagRow {
        let isSelected = selectedLocationTag == tag
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

struct TagSelectionList_Previews: PreviewProvider {
    static var previews: some View {
        TagSelectionList(tagState: .init(), tags: [Tag.preview, Tag.preview, Tag.preview, Tag.preview, Tag.preview, Tag.preview], onSelect: {_ in}, selectedLocationTag: nil)
    }
}
