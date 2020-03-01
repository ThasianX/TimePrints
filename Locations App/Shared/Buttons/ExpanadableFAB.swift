// Kevin Li - 10:06 AM - 2/23/20

import SwiftUI

struct ExpanadableFAB: View {
    @State private var isOpen = false

    let menuInputs: [MenuInput]
    var fabImage: Image = .init(systemName: "plus")
    var fabColor: Color = .pink

    var body: some View {
        ZStack {
            menuInputsToView

            Button(action: toggleOpen) {
                fabImage
                    .rotationEffect(.degrees(isOpen ? 45 : 0))
                    .foregroundColor(.white)
                    .font(.system(size: 38, weight: .bold))
                    .animation(.spring(response: 0.2, dampingFraction: 0.4, blendDuration: 0))
            }
            .padding(24)
            .background(fabColor)
            .mask(Circle())
            .shadow(color: fabColor, radius: 10)
            .scaleEffect(isOpen ? 1 : 0.7)
            .animation(.spring())
        }
    }

    private func toggleOpen() {
        isOpen.toggle()
    }

    private var menuInputsToView: some View {
        ForEach(0..<menuInputs.count, id: \.self) { i in
            MenuButton(isOpen: self.$isOpen, menuInput: self.menuInputs[i])
        }
    }
}

extension ExpanadableFAB {
    struct MenuInput {
        let action: () -> Void
        let icon: String
        let color: Color
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        var delay: Double = 0.0
    }

    struct MenuButton: View {
        @Binding var isOpen: Bool
        let menuInput: MenuInput

        var body: some View {
            Button(action: onTap) {
                Image(systemName: menuInput.icon)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
            }
            .buttonStyle(ScaleButtonStyle())
            .padding()
            .background(menuInput.color)
            .mask(Circle())
            .offset(x: isOpen ? menuInput.offsetX : 0, y: isOpen ? menuInput.offsetY : 0)
            .scaleEffect(isOpen ? 1 : 0.1)
            .animation(Animation.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0).delay(menuInput.delay))
        }

        private func onTap() {
            menuInput.action()
            isOpen = false
        }
    }

}

struct ExpanadableFAB_Previews: PreviewProvider {
    static var previews: some View {
        ExpanadableFAB(
            menuInputs: [
                .init(action: { }, icon: "pencil", color: .blue, offsetY: -90),
                .init(action: { }, icon: "trash", color: .gray, offsetX: -60, offsetY: -60, delay: 0.1),
                .init(action: { }, icon: "flame.fill", color: .red, offsetX: -90, delay: 0.2)
        ])
    }
}
