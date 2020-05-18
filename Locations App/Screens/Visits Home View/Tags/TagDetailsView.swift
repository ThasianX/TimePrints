// Kevin Li - 9:16 PM - 2/27/20

import SwiftUI

struct TagDetailsView: View {
    let tag: Tag

    @Binding var selectedTag: Tag?

    private var isSelected: Bool {
        selectedTag == tag
    }

    var body: some View {
        tagDetailsView
            .padding(.top, isSelected ? 80 : 12)
            .padding([.bottom, .horizontal], 12)
            .frame(height: TagCellConstants.height(if: isSelected))
            .frame(maxWidth: TagCellConstants.maxWidth(if: isSelected))
            .extendToScreenEdges()
            .background(tag.uiColor.color)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .animation(.spring())
            .onTapGesture(perform: setSelectedTag)
    }
}

private extension TagDetailsView {
    private var tagDetailsView: some View {
        VStack {
            tagDetailsHeaderView
            if isSelected {
                LocationsForTagView(tag: tag)
                Spacer()
            }
        }
    }

    private var tagDetailsHeaderView: TagDetailsHeaderView {
        TagDetailsHeaderView(tag: tag)
    }
}

private extension TagDetailsView {
    private func setSelectedTag() {
        selectedTag = tag
    }
}

struct TagDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TagDetailsView(tag: .preview, selectedTag: .constant(nil))
    }
}
