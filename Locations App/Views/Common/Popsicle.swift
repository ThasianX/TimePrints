import SwiftUI

struct Popsicle: View {
    let tag: Tag
    var displayName = false
    
    var body: some View {
        Group {
            if displayName {
                Text(tag.name.uppercased())
                    .font(.caption)
                    .padding(6)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .fill(Color(tag.color)))
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(tag.color))
                    .frame(width: 5, height: 30)
            }
        }
    }
}

struct Popsicle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Popsicle(tag: Tag.preview, displayName: true)
            Popsicle(tag: Tag.preview, displayName: false)
        }.previewLayout(.sizeThatFits)
    }
}
