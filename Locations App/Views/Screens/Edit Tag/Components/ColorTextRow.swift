import SwiftUI

struct ColoredTextRow: View {
    let text: String
    let color: UIColor
    let selected: Bool
    var useStaticForegroundColor: Bool = false
    
    var body: some View {
        HStack {
            tagColorCircle
            tagNameText
            Spacer()
            checkmarkIfIsSelected
        }
        .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
        .background(Color.clear)
        .contentShape(Rectangle())
    }
}

private extension ColoredTextRow {
    private var tagColorCircle: some View {
        Circle()
            .fill(Color(color))
            .frame(width: 20, height: 20)
    }
    
    private var tagNameText: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(foregroundColor)
            .lineLimit(nil)
    }
    
    private var checkmarkIfIsSelected: some View {
        Group {
            if selected {
                Image(systemName: "checkmark")
                    .foregroundColor(foregroundColor)
            }
        }
    }
}

private extension ColoredTextRow {
    private var foregroundColor: Color? {
        useStaticForegroundColor ? .white : nil
    }
}

struct ColorTextRow_Previews: PreviewProvider {
    static var previews: some View {
        ColoredTextRow(text: "Salmon", color: .salmon, selected: true)
    }
}
