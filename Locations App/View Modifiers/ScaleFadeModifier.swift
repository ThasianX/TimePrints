import SwiftUI

struct ScaleFadeModifier: ViewModifier {
    let condition: Bool
    func body(content: Content) -> some View {
        content
            .scaleEffect(condition ? 0 : 1)
            .fade(if: condition)
            .animation(.spring())
    }
}
