import SwiftUI

struct BackgroundModifier: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content.background(RoundedRectangle(cornerRadius: 16).stroke(color).background(color).cornerRadius(16))
    }
}
