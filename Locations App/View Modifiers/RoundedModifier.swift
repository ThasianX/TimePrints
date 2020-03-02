import SwiftUI

struct RoundedModifier: ViewModifier {
    let radius: CGFloat
    let corners: UIRectCorner

    func body(content: Content) -> some View {
        content.clipShape(RoundedCorner(radius: radius, corners: corners))
    }

    private struct RoundedCorner: Shape {
        let radius: CGFloat
        let corners: UIRectCorner

        func path(in rect: CGRect) -> Path {
            Path(
                UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
            )
        }
    }
}
