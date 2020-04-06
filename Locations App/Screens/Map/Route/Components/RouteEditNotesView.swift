import SwiftUI

struct RouteEditNotesView: View {
    @Binding var overlayState: RouteOverlayState
    let visit: Visit

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                header

                Group {
                    if overlayState.isEditingNotes {
                        notesTextField
                        Spacer()
                    }
                }
                .scaleFade(if: !overlayState.isEditingNotes)
                .animation(.spring())
            }
        }
        .padding(.top, overlayState.isEditingNotes ? 100 : 0)
        .padding(.horizontal, overlayState.isEditingNotes ? 50 : 0)
        .frame(width: overlayState.isEditingNotes ? screen.width : nil, height: overlayState.isEditingNotes ? screen.height : nil)
    }

}

private extension RouteEditNotesView {
    private var header: some View {
        RouteEditNotesHeader(isButton: !overlayState.isEditingNotes, onButtonTap: adjustEditingState)
    }

    private func adjustEditingState() {
        if overlayState.isEditingNotes {
            withAnimation {
                resetNoteState()
            }
        } else {
            withAnimation {
                overlayState = .editingNotes
            }
        }
    }

    private func resetNoteState() {
        overlayState = .normal
        UIApplication.shared.endEditing(true)
    }

    private var notesTextField: some View {
        let notesInput = Binding(
            get: { self.visit.notes },
            set: { self.visit.notes = $0 })

        return AutoResizingTextField(text: notesInput, isActive: overlayState.isEditingNotes)
            .padding()
            .background(BlurView(style: .dark))
            .cornerRadius(10)
    }

}

struct EditNotesView_Previews: PreviewProvider {
    static var previews: some View {
        RouteEditNotesView(overlayState: .constant(.editingNotes), visit: .preview)
    }
}
