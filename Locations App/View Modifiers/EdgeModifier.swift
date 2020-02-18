import SwiftUI

struct EdgeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.edgesIgnoringSafeArea(.all)
    }
}
