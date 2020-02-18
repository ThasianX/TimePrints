import SwiftUI

struct TapModifier: ViewModifier {
    
    let action: () -> Void
    
    init(perform action: @escaping () -> Void) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    self.action()
                }
        }
    }
}
