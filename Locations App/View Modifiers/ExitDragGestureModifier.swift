// Kevin Li - 10:52 AM - 5/24/20

import SwiftUI

struct ExitDragGestureModifier: ViewModifier {
    @State var activeTranslation: CGSize = .zero

    let isSelected: Bool
    let onExit: () -> Void

    private var exitGestureIfSelected: some Gesture {
        return isSelected ? exitGesture : nil
    }

    private var exitGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let height = value.translation.height
                let width = value.translation.width
                guard height > 0 && height < 100 else { return }
                guard width > 0 && width < 50 else { return }

                self.activeTranslation = value.translation
            }
            .onEnded { value in
                if self.activeTranslation.height > 50 || self.activeTranslation.width > 30 {
                    self.onExit()
                }
                self.resetActiveTranslation()
            }
    }

    private func resetActiveTranslation() {
        activeTranslation = .zero
    }

    func body(content: Content) -> some View {
        content
            .scaleEffect(1 - ((activeTranslation.height + activeTranslation.width) / 1000))
            .gesture(exitGestureIfSelected)
    }
}
