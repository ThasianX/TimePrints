import SwiftUI

struct TagView: View {
    let tag: Tag
    var displayName = false
    
    var body: some View {
        ZStack {
            if displayName {
                name
            }
        }
        .id(tag.color)
        .frame(width: displayName ? nil : 30, height: displayName ? nil : 5)
        .background(roundedAndFilledRectangle)
        .animation(.spring())
    }
}

private extension TagView {
    private var name: some View {
        Text(tag.name.uppercased())
            .font(.caption)
            .padding(6)
    }
    
    private var roundedAndFilledRectangle: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(tag.uiColor))
    }
}

struct Popsicle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TagView(tag: Tag.preview, displayName: true)
            TagView(tag: Tag.preview, displayName: false)
        }.previewLayout(.sizeThatFits)
    }
}
