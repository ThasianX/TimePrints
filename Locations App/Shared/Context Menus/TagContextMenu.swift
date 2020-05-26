// Kevin Li - 7:48 PM - 4/18/20 - macOS 10.15

import SwiftUI

struct TagContextMenu: View {
    @ObservedObject var tagState: TagCoreState

    let tag: Tag

    var body: some View {
        contextMenu
    }

    private var contextMenu: some View {
        VStack {
            editButton
            deleteButton
        }
    }

    private var editButton: some View {
        Button(action: setTagToEdit) {
            editTextPrecededByPencil
        }
    }

    private func setTagToEdit() {
        tagState.operation.setTagToEdit(tag)
    }

    private var editTextPrecededByPencil: some View {
        HStack {
            Text("Edit")
            Image(systemName: "pencil")
        }
    }

    private var deleteButton: some View {
        Button(action: removeTag) {
            deleteTextPrecededByTrash
        }
    }

    private func removeTag() {
        tagState.removeTag(tag)
    }

    private var deleteTextPrecededByTrash: some View {
        HStack {
            Text("Delete")
            Image(systemName: "trash.fill")
        }
    }
}
