import SwiftUI

struct RotatedModifier: ViewModifier {
    @State private var size: CGSize = .zero
    var angle: Angle
    
    func body(content: Content) -> some View {
        let newFrame = CGRect(origin: .zero, size: size)
            .offsetBy(dx: -size.width / 2, dy: -size.height / 2)
            .applying(.init(rotationAngle: CGFloat(angle.radians)))
            .integral
        
        return content
            .fixedSize()
            .captureSize(in: $size)
            .rotationEffect(angle)
            .frame(width: newFrame.width, height: newFrame.height)
    }
}

private extension View {
    func captureSize(in binding: Binding<CGSize>) -> some View {
        modifier(SizeModifier())
            .onPreferenceChange(SizePreferenceKey.self) {
                binding.wrappedValue = $0
        }
    }
}
