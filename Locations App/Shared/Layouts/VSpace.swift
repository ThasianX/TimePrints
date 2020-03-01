import SwiftUI

struct VSpace: View {
    let space: CGFloat
    
    init(_ space: CGFloat) {
        self.space = space
    }
    
    var body: some View {
        Spacer().frame(height: space)
    }
}

struct Space_Previews: PreviewProvider {
    static var previews: some View {
        VSpace(10).previewLayout(.sizeThatFits)
    }
}
