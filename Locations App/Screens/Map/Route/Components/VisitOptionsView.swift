import SwiftUI

struct VisitOptionsView: View {
    @Binding var overlayState: RouteOverlayState

    let tagProvider: TagProvider
    let visit: Visit

    var body: some View {
        HStack {
            Group {
                if !overlayState.isEditingNotes {
                    routeEditTagView
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

    private var routeEditTagView: RouteEditTagView {
        RouteEditTagView(overlayState: $overlayState, tagProvider: tagProvider)
    }

    private var editNotesButton: some View {
        BImage(perform: setStateToEditingNotes, image: Image(systemName: "text.bubble.fill"))
    }

    private func setStateToEditingNotes() {
        overlayState = .editingNotes
    }

    private var favoriteButton: some View {
        FavoriteButton(visit: visit)
            .id(visit.isFavorite)
    }
}

struct VisitOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        VisitOptionsView(overlayState: .constant(.normal), tagProvider: AppState.Route.init(), visit: .preview)
    }
}

