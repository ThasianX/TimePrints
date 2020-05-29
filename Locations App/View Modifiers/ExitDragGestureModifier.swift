// Kevin Li - 10:52 AM - 5/24/20

import SwiftUI

// if user drags by at least 50 pixels downward, we can exit the view
fileprivate let lowerBoundHeight: CGFloat = 50
// if user drags by more than 100 pixels downward, don't let the user drag down anymore
fileprivate let upperBoundHeight: CGFloat = 100
fileprivate let lowerBoundWidth: CGFloat = 30
fileprivate let upperBoundWidth: CGFloat = 50

struct ExitDragGestureModifier: ViewModifier {
    @State private var activeTranslation: CGSize = .zero

    let isSelected: Bool
    let onExit: () -> Void
    let isSimultaneous: Bool

    private var exitGestureIfSelected: some Gesture {
        return isSelected ? exitGesture : nil
    }

    private var exitGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let height = value.translation.height
                let width = value.translation.width
                guard height > 0 && height < upperBoundHeight else { return }
                guard width > 0 && width < upperBoundWidth else { return }

                self.activeTranslation = value.translation
            }
            .onEnded { value in
                if self.activeTranslation.height > lowerBoundHeight ||
                    self.activeTranslation.width > lowerBoundWidth {
                    self.onExit()
                }
                self.resetActiveTranslation()
            }
    }

    private func resetActiveTranslation() {
        activeTranslation = .zero
    }

    func body(content: Content) -> some View {
        // There's probably a better way to do this with viewbuilder
        Group {
            if isSimultaneous {
                content
                    .scaleEffect(1 - ((activeTranslation.height + activeTranslation.width) / 1000))
                    .simultaneousGesture(exitGestureIfSelected)
            } else {
                content
                    .scaleEffect(1 - ((activeTranslation.height + activeTranslation.width) / 1000))
                    .gesture(exitGestureIfSelected)
            }
        }
    }
}
