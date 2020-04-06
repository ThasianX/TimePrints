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

    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        modifier(RoundedModifier(radius: radius, corners: corners))
    }

    func scaleFade(if condition: Bool) -> some View {
        modifier(ScaleFadeModifier(condition: condition))
    }
}

extension View {
    func erased() -> AnyView {
        AnyView(self)
    }
}
