import Introspect
import SwiftUI

struct TagOperationsView: View {
    @ObservedObject var tagState: TagCoreState

    var body: some View {
        VStack {
            tagNameTextField
                .padding(.init(top: 0, leading: 30, bottom: 0, trailing: 30))

            tagColorPicker
        }
    }

    private var tagNameTextField: some View {
        let nameInput = Binding(
            get: { self.tagState.operation.nameInput },
            set: { self.tagState.operation.nameInput = $0 })

        return TextField("Tag Name...", text: nameInput)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .multilineTextAlignment(.center)
            .introspectTextField { textField in
                if self.tagState.isShowingAddOrEdit {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        textField.becomeFirstResponder()
                    }
                }
            }
    }

    private var tagColorPicker: some View {
        let selectedColorIndex = Binding(
            get: { self.tagState.operation.selectedColorIndex },
            set: { self.tagState.operation.selectedColorIndex = $0 })

        return Picker(selection: selectedColorIndex, label: Text("")) {
            ForEach(0..<AppColors.identifiers.count) { index in
                self.coloredTextRow(at: index)
                    .tag(index)
            }
        }
        .labelsHidden()
    }

    private func coloredTextRow(at index: Int) -> ColoredTextRow {
        ColoredTextRow(text: AppColors.identifiers[index], color: AppColors.tags[AppColors.identifiers[index]]!, selected: false, useStaticForegroundColor: true)
    }
}

struct TagOperationsView_Previews: PreviewProvider {
    static var previews: some View {
        TagOperationsView(tagState: .init())
    }
}
