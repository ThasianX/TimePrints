import SwiftUI

struct RouteEditTagView: View {
    @FetchRequest(
        entity: Tag.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Tag.name, ascending: true)
        ]
    ) var tags: FetchedResults<Tag>

    @ObservedObject var tagState: AddNewTagState = .init()
    @State private var isAnimatingSelection: Bool = false

    @Binding var overlayState: RouteOverlayState
    let tagProvider: TagProvider

    var body: some View {
        ZStack(alignment: .top) {
            header
                .padding(overlayState.isEditingTag ? 16 : 0)
                .offset(y: tagState.isShowingAddOrEdit ? 250 : 0)

            Group {
                if overlayState.isEditingTag {
                    tagSelectionList
                        .padding(.bottom, overlayState.isEditingTag ? 125 : 0)
                        .offset(y: 60)
                        .scaleFade(if: tagState.isShowingAddOrEdit)

                    topAlignedTagOperationsView
                        .padding()
                        .scaleFade(if: tagState.isntShowingAddNorEdit)

                    bottomAlignedTransientAlertView
                        .fade(if: tagState.alert.isInactive)
                }
            }
            .scaleFade(if: !overlayState.isEditingTag)
        }
        .disabled(isAnimatingSelection)
        .padding(.top, overlayState.isEditingTag ? 100 : 0)
        .padding(.bottom, overlayState.isEditingTag ? 50 : 0)
        .frame(width: overlayState.isEditingTag ? screen.width : nil, height: overlayState.isEditingTag ? screen.height : nil)
        .animation(.spring())
    }
}

private extension RouteEditTagView {
    private var header: some View {
        RouteTagHeader(
            tagState: tagState,
            isButton: !overlayState.isEditingTag,
            onButtonTap: startEditingTag,
            normalTagColor: tagProvider.normalTagColor,
            onSelect: setTagAndExitView)
    }

    private func startEditingTag() {
        if !overlayState.isEditingTag {
            withAnimation {
                overlayState = .editingTag
            }
        }
    }

    private var tagSelectionList: some View {
        TagSelectionList(
            tagState: tagState,
            tags: Array(tags),
            onSelect: setTagAndExitView,
            selectedLocationTag: tagProvider.selectedLocation?.tag)
    }

    private var topAlignedTagOperationsView: some View {
        VStack {
            TagOperationsView(tagState: tagState)
            Spacer()
        }
    }

    private var bottomAlignedTransientAlertView: some View {
        VStack {
            Spacer()
            TransientAlertView(tagState: tagState)
                .padding()
        }
    }
}

private extension RouteEditTagView {
    private func setTagAndExitView(tag: Tag) {
        if tagProvider.selectedLocation!.tag == tag {
            resetView()
            return
        }

        tagProvider.selectedLocation!.setTag(tag: tag)
        isAnimatingSelection = true

        // 1.5 seconds is duration it takes for the checkmark lottie to finish
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.resetView()
        }

        // This line is necessary because it's possible to tap on the closing modal view which will cause an error
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.isAnimatingSelection = false
        }
    }

    private func resetView() {
        overlayState = .normal
        tagState.alert.stop()
    }
}
struct RouteEditTagView_Previews: PreviewProvider {
    static var previews: some View {
        RouteEditTagView(overlayState: .constant(.editingTag), tagProvider: AppState.Route.init(visits: Visit.previewVisits))
    }
}

