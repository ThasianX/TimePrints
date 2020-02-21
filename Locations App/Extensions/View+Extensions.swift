import SwiftUI

extension View {
    func captureSize(in binding: Binding<CGSize>) -> some View {
        modifier(SizeModifier())
            .onPreferenceChange(SizePreferenceKey.self) {
                binding.wrappedValue = $0
        }
    }
    
    func rotated(_ angle: Angle) -> some View {
        modifier(RotatedModifier(angle: angle))
    }
    
    func extendToScreenEdges() -> some View {
        modifier(EdgeModifier())
    }
    
    func roundedFill(with color: Color) -> some View {
        modifier(BackgroundModifier(color: color))
    }
    
    func roundedFill(with color: UIColor) -> some View {
        modifier(BackgroundModifier(color: Color(color)))
    }
    
    func onTap(perform action: @escaping () -> Void) -> some View {
        modifier(TapModifier(perform: action))
    }
    
    func disablur(_ disabled: Bool) -> some View {
        modifier(DisableModifier(disabled: disabled))
    }
    
    func fade(if condition: Bool) -> some View {
        modifier(OpacityModifier(fade: condition))
    }
    
    func erase() -> AnyView {
        AnyView(self)
    }
}
