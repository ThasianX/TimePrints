import SwiftUI

struct TagView: View {
    let tag: Tag
    var displayName = false
    
    var body: some View {
        ZStack {
            content
        }
        .frame(width: displayName.when(true: nil, false: 30), height: displayName.when(true: nil, false: 5))
        .background(roundedAndFilledRectangle)
        .animation(.spring())
    }
}

// MARK: - Content
private extension TagView {
    private var content: some View {
        Text(tag.name.uppercased())
            .font(.caption)
            .padding(6)
            .animation(nil)
            .fade(if: !displayName)
            .scaleEffect(displayName.when(true: 1, false: 0.1))
    }
    
    private var roundedAndFilledRectangle: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(.green))
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
