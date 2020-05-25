import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        modifier(RoundedModifier(radius: radius, corners: corners))
    }

    func disablur(_ disabled: Bool) -> some View {
        modifier(DisableModifier(disabled: disabled))
    }

    func exitOnDrag(if isSelected: Bool, onExit: @escaping () -> Void) -> some View {
        modifier(ExitDragGestureModifier(isSelected: isSelected, onExit: onExit))
    }

    func expandableAndFoldable(foldOffset: CGFloat, shouldFold: Bool, isActiveIndex: Bool) -> some View {
        modifier(ExpandAndFoldModifier(
            foldOffset: foldOffset,
            shouldFold: shouldFold,
            isActiveIndex: isActiveIndex))
    }
    
    func extendToScreenEdges() -> some View {
        modifier(EdgeModifier())
    }
    
    func fade(if condition: Bool) -> some View {
        modifier(OpacityModifier(fade: condition))
    }

    func resignKeyboardOnDrag() -> some View {
        modifier(ResignKeyboardOnDragGesture())
    }

    func rotated(_ angle: Angle) -> some View {
        modifier(RotatedModifier(angle: angle))
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
