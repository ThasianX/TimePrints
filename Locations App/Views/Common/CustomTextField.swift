import SwiftUI

struct AutoResizingTextField: View {
    @State private var dynamicHeight: CGFloat = 100

    @Binding var isActive: Bool
    @Binding var text: String

    let onCommit: () -> Void
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        CustomTextField(isActive: $isActive, text: $text, calculatedHeight: $dynamicHeight, onCommit: onCommit, keyboardType: keyboardType)
            .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
    }
}

struct CustomTextField: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var isActive: Bool
    @Binding var text: String
    @Binding var calculatedHeight: CGFloat

    let onCommit: () -> Void
    let keyboardType: UIKeyboardType

    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator
        textField.isEditable = true
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = true
        textField.keyboardType = keyboardType
        textField.returnKeyType = .done
        textField.backgroundColor = .clear
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.textColor = .black
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
        if isActive && !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        }
        recalculateHeight(view: uiView)
    }

    fileprivate func recalculateHeight(view: UIView) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if calculatedHeight != newSize.height {
            DispatchQueue.main.async {
                self.calculatedHeight = newSize.height
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextField

        init(_ parent: CustomTextField) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            parent.recalculateHeight(view: textView)
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder()
                parent.isActive = false
                parent.onCommit()
                return false
            }
            return true
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        AutoResizingTextField(isActive: .constant(true), text: .constant(""), onCommit: { })
    }
}
