import SwiftUI

struct AutoResizingTextField: View {
    @State private var dynamicHeight: CGFloat = 100

    @Binding var text: String

    let isActive: Bool
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        CustomTextField(text: $text, calculatedHeight: $dynamicHeight, isActive: isActive, keyboardType: keyboardType)
            .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
    }
}

struct CustomTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var calculatedHeight: CGFloat

    let isActive: Bool
    let keyboardType: UIKeyboardType

    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator
        textField.isEditable = true
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = true
        textField.keyboardType = keyboardType
        textField.backgroundColor = .clear
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.textColor = .white
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return textField
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
        if isActive && !uiView.isFirstResponder {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                uiView.becomeFirstResponder()
            }
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
    }
}

extension UITextView {
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
       self.resignFirstResponder()
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        AutoResizingTextField(text: .constant(""), isActive: true)
    }
}
