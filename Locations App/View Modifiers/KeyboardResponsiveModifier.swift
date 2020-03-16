import SwiftUI

struct KeyboardResponsiveModifier: ViewModifier {
    @State private var offset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, offset)
            .onAppear(perform: addKeyboardNotifications)
    }

    private func addKeyboardNotifications() {
        addKeyboardWillShowNotification()
        addKeyboardWillHideNotification()
    }

    private func addKeyboardWillShowNotification() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notif in
            let value = notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let height = value.height
            let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom
            self.offset = height - (bottomInset ?? 0)
        }
    }

    private func addKeyboardWillHideNotification() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            self.offset = 0
        }
    }
}
