// Kevin Li - 7:41 PM - 4/18/20 - macOS 10.15

import SwiftUI

struct TagPreviewList: View {
    @ObservedObject var tagState: TagCoreState
    @Binding var selectedTag: Tag?
    @Binding var hideFAB: Bool

    let tags: [Tag]
    let setActiveLocationAndDisplayMap: (Location) -> Void

    private var isShowingTag: Bool {
        selectedTag != nil
    }

    private var tagsUpToSelectedTag: [Tag] {
        if let selectedTag = selectedTag,
            let index = tags.firstIndex(of: selectedTag) {
            return Array(tags.prefix(through: index))
        }
        return tags
    }

    var body: some View {
        tagPreviewList
    }

    private var tagPreviewList: some View {
        VScroll {
            tagPreviewStack
                .frame(width: screen.width)
                // Necessary for shorter lists to fill up the gap in size
                // after the offset. This makes the content in the expanded
                // row clickable and interactable
                .padding(.bottom, 650)
        }
    }

    private var tagPreviewStack: some View {
        VStack {
            ForEach(tagsUpToSelectedTag) { tag in
                self.dynamicTagRow(tag: tag)
                    .id(tag.name)
                    .id(tag.color)
                    .id(tag.locations.count)
                    .padding(.horizontal, self.isShowingTag ? 0 : 16)
                    .frame(height: TagCellConstants.height)
                    .frame(maxWidth: TagCellConstants.maxWidth(if: self.isShowingTag))
            }
        }
    }

    private func dynamicTagRow(tag: Tag) -> some View {
        GeometryReader { geometry in
            self.tagDetailsView(tag: tag)
                .contextMenu {
                    self.isShowingTag ? nil : TagContextMenu(tagState: self.tagState, tag: tag)
                }
                .offset(y: self.isTagActive(tag) ? self.topOfScreen(for: geometry) : 0)
        }
    }

    private func tagDetailsView(tag: Tag) -> TagDetailsView {
        TagDetailsView(
            tag: tag,
            selectedTag: $selectedTag,
            hideFAB: $hideFAB,
            setActiveLocationAndDisplayMap: setActiveLocationAndDisplayMap)
    }

    private func isTagActive(_ tag: Tag) -> Bool {
        tag == selectedTag
    }

    private func topOfScreen(for proxy: GeometryProxy) -> CGFloat {
        -proxy.frame(in: .global).minY
    }
}

struct TagPreviewList_Previews: PreviewProvider {
    static var previews: some View {
        TagPreviewList(tagState: .init(), selectedTag: .constant(nil), hideFAB: .constant(true), tags: [.preview], setActiveLocationAndDisplayMap: { _ in })
    }
}
