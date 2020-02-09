import SwiftUI

struct ScreenColor: View {
    let color: Color
    
    @inlinable init(_ color: Color) {
        self.color = color
    }
    
    @inlinable init(_ color: UIColor) {
        self.color = Color(color)
    }
    
    var body: some View {
        color
            .extendToScreenEdges()
    }
}

struct ScreenColor_Previews: PreviewProvider {
    static var previews: some View {
        ScreenColor(UIColor.black)
    }
}
