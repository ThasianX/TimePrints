// Kevin Li - 9:16 PM - 2/27/20

import SwiftUI

struct TagDetailsView: View {
    let tag: Tag

    @Binding var selectedTag: Tag?
    @Binding var hideFAB: Bool

    let setActiveLocationAndDisplayMap: (Location) -> Void

    private var isSelected: Bool {
        selectedTag == tag
    }

    var body: some View {
        tagDetailsView
            .animation(.spring())
            .padding(.top, isSelected ? 80 : 12)
            .padding(.bottom, isSelected ? 0 : 12)
            .frame(height: TagCellConstants.height(if: isSelected))
            .frame(maxWidth: TagCellConstants.maxWidth(if: isSelected))
            .extendToScreenEdges()
            .background(tag.uiColor.color)
            .clipShape(RoundedRectangle(cornerRadius: isSelected ? 30 : 15, style: .continuous))
            .animation(.easeInOut)
            .exitOnDrag(if: isSelected, onExit: navigateBack)
    }
}

private extension TagDetailsView {
    private var tagDetailsView: some View {
        VStack {
            tagDetailsHeaderView
                .equatable()
                .contentShape(Rectangle())
                .onTapGesture(perform: setSelectedTag)
            if isSelected {
                LocationsForTagView(
                    tag: tag,
                    setActiveLocationAndDisplayMap: setActiveLocationAndDisplayMap)
            }
        }
    }
    private func setSelectedTag() {
        withAnimation {
            selectedTag = tag
            hideFAB = true
        }
    }

    private var tagDetailsHeaderView: TagDetailsHeaderView {
        TagDetailsHeaderView(tag: tag, isSelected: isSelected, navigateBack: navigateBack)
    }

    private func navigateBack() {
        withAnimation {
            selectedTag = nil
            hideFAB = false
        }
    }
}

struct TagDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TagDetailsView(tag: .preview, selectedTag: .constant(nil), hideFAB: .constant(true), setActiveLocationAndDisplayMap: { _ in })
    }
}
