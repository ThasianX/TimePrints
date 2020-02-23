import SwiftUI

extension View {
    func rotated(_ angle: Angle) -> some View {
        modifier(RotatedModifier(angle: angle))
    }
    
    func extendToScreenEdges() -> some View {
        modifier(EdgeModifier())
    }
    
    func disablur(_ disabled: Bool) -> some View {
        modifier(DisableModifier(disabled: disabled))
    }
    
    func fade(if condition: Bool) -> some View {
        modifier(OpacityModifier(fade: condition))
    }
    
    func erased() -> AnyView {
        AnyView(self)
    }
}
