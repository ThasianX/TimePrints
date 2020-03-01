import SwiftUI

struct V0Stack<Content: View>: View {
    private let content: Content
    
    @inlinable init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0, content: { content })
    }
}

struct V0Stack_Previews: PreviewProvider {
    static var previews: some View {
        V0Stack {
            Text("A")
            Text("B")
            Text("C")
        }
    }
}
