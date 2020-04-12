import SwiftUI

struct VisitOptionsView: View {
    @Binding var overlayState: RouteOverlayState

    let tagProvider: TagProvider
    let visit: Visit

    var body: some View {
        HStack {
            Group {
                if !overlayState.isEditingNotes {
                    editTagButton
                    Spacer()
                }
            }
            .scaleFade(if: overlayState.isEditingNotes)

            Group {
                if !overlayState.isEditingTag {
                    editNotesButton
                    Spacer()
                }
            }
            .scaleFade(if: overlayState.isEditingTag)

            Group {
                if overlayState.isNormal {
                    favoriteButton
                }
            }
            .scaleFade(if: !overlayState.isNormal)
        }
        .padding()
    }

    private var editTagButton: RouteEditTagView {
        RouteEditTagView(overlayState: $overlayState, tagProvider: tagProvider)
    }

    private var editNotesButton: some View {
        RouteEditNotesView(overlayState: $overlayState, visit: visit)
    }

    private var favoriteButton: some View {
        FavoriteButton(visit: visit)
            .id(visit)
    }
}

struct VisitOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        VisitOptionsView(overlayState: .constant(.normal), tagProvider: AppState.Route.init(), visit: .preview)
    }
}

