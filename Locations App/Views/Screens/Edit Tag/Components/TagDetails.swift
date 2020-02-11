import SwiftUI

struct TagDetails: View {
    @Binding var nameInput: String
    @Binding var selectedColorIndex: Int
    
    let colors: [String : UIColor]
    let colorNames: [String]
    
    var body: some View {
        VStack {
            tagNameTextField
                .padding(.init(top: 0, leading: 30, bottom: 0, trailing: 30))
            
            tagColorPicker
        }
    }
}

private extension TagDetails {
    private var tagNameTextField: some View {
        TextField("Tag Name...", text: $nameInput)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .multilineTextAlignment(.center)
    }
    
    private var tagColorPicker: some View {
        Picker(selection: $selectedColorIndex, label: Text("")) {
            ForEach(0..<colorNames.count) {
                ColoredTextRow(text: self.colorNames[$0], color: self.colors[self.colorNames[$0]]!, selected: false, useStaticForegroundColor: true)
            }
        }
        .labelsHidden()
    }
}

struct TagDetails_Previews: PreviewProvider {
    static var previews: some View {
        TagDetails(nameInput: .constant(""), selectedColorIndex: .constant(2), colors: AppColors.tags, colorNames: AppColors.tags.ascendingKeys)
    }
}
