import SwiftUI

struct ScaleFadeModifier: ViewModifier {
    let condition: Bool
    func body(content: Content) -> some View {
        content
            .fade(if: condition)
            .scaleEffect(condition ? 0.1 : 1)
    }
}
