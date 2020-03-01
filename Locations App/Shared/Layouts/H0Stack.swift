import SwiftUI

struct H0Stack<Content: View>: View {
    private let content: Content
    
    @inlinable init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: 0, content: { content })
    }
}

struct H0Stack_Previews: PreviewProvider {
    static var previews: some View {
        H0Stack {
            Text("A")
            Text("B")
            Text("C")
        }
    }
}
