import SwiftUI

struct OpacityModifier: ViewModifier {
    let fade: Bool
    
    func body(content: Content) -> some View {
        content
            .opacity(fade ? 0 : 1)
    }
}
