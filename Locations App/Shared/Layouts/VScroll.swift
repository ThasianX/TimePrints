import SwiftUI

struct VScroll<Content: View>: View {
    private let content: Content
    
    @inlinable init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: { content })
    }
}

struct VScroll_Previews: PreviewProvider {
    static var previews: some View {
        VScroll {
            Text("A")
            Text("B")
            Text("C")
        }
    }
}
