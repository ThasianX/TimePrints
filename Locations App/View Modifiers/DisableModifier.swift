import SwiftUI

struct DisableModifier: ViewModifier {
    let disabled: Bool
    
    func body(content: Content) -> some View {
        content
            .allowsHitTesting(!disabled)
            .blur(radius: disabled ? 20 : 0)
    }
}
