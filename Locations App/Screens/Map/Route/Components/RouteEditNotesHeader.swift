// Kevin Li - 1:37 PM - 4/4/20 - macOS 10.15

import SwiftUI

struct RouteEditNotesHeader: View {
    let isButton: Bool
    let onButtonTap: () -> Void

    var body: some View {
        editNotesHeaderView
            .padding(.horizontal, isButton ? 0 : 16)
    }

    private var editNotesHeaderView: some View {
        HStack {
            notesImage
                .onTapGesture(perform: onButtonTap)

            if !isButton {
                notesText
            }
        }
        .animation(.easeInOut)
    }

    private var notesImage: some View {
        ZStack {
            Image(systemName: "text.bubble.fill")
                .fade(if: !isButton)
            Image(systemName: "xmark.circle.fill")
                .fade(if: isButton)
        }
        .foregroundColor(.white)
    }

    private var notesText: some View {
        Text("Notes")
            .tracking(5)
            .font(.system(size: 20))
            .bold()
            .foregroundColor(.white)
    }

}

struct RouteEditNotesHeader_Previews: PreviewProvider {
    static var previews: some View {
        RouteEditNotesHeader(isButton: false, onButtonTap: { })
    }
}
