import SwiftUI

struct EditTagHeaderText: View {
    let showAdd: Bool
    let showEdit: Bool
    let selectedColor: Color
    let location: Location?
    
    var body: some View {
        HStack {
            tagImage
            
            ZStack {
                headerText("CHOOSE TAG")
                    .fade(isShowingAddOrEdit)
                headerText("MAKE TAG")
                    .fade(!showAdd)
                headerText("EDIT TAG")
                    .fade(!showEdit)
            }
        }
        .animation(.easeInOut)
    }
}

private extension EditTagHeaderText {
    private var tagImage: some View {
        Image(systemName: "tag.fill")
            .foregroundColor(.white)
            .colorMultiply(isShowingAddOrEdit.when(true: selectedColor, false: defaultTagColor))
    }
    
    private func headerText(_ text: String) -> some View {
        Text(text)
            .tracking(5)
            .font(.system(size: 20))
            .bold()
            .foregroundColor(.white)
    }
}

private extension EditTagHeaderText {
    private var isShowingAddOrEdit: Bool {
        showAdd || showEdit
    }
    
    private var defaultTagColor: Color {
        location != nil ? Color(location!.accent) : .clear
    }
}

struct EditTagHeader_Previews: PreviewProvider {
    static var previews: some View {
        EditTagHeaderText(showAdd: false, showEdit: false, selectedColor: Color(UIColor.salmon), location: .preview)
    }
}
