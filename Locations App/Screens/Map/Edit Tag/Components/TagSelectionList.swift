import SwiftUI

struct TagSelectionList: View {
    @ObservedObject var tagState: TagCoreState

    let tags: [Tag]
    let onSelect: (Tag) -> Void
    var selectedLocationTag: Tag? = nil

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
                    .id(tag.locations.count)
            }
        }
    }

    private func interactiveColoredTextRow(tag: Tag) -> some View {
        coloredTextRow(tag: tag)
            .onTapGesture {
                self.onSelect(tag)
            }
            .contextMenu {
                TagContextMenu(tagState: tagState, tag: tag)
            }
    }

    private func coloredTextRow(tag: Tag) -> TagRow {
        TagRow(tag: tag, isSelected: selectedLocationTag == tag)
    }
}

struct TagSelectionList_Previews: PreviewProvider {
    static var previews: some View {
        TagSelectionList(tagState: .init(), tags: [Tag.preview, Tag.preview, Tag.preview, Tag.preview, Tag.preview, Tag.preview], onSelect: {_ in}, selectedLocationTag: nil)
    }
}
