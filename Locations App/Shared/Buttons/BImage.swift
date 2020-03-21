import SwiftUI

struct BImage: View {
    @Binding var condition: Bool
    let perform: () -> Void
    let image: Image
    let scale: Bool
    let frame: CGSize?
    
    init(condition: Binding<Bool>, image: Image, scale: Bool = true, frame: CGSize? = nil) {
        self._condition = condition
        self.perform = {}
        self.image = image
        self.scale = scale
        self.frame = frame
    }
    
    init(perform: @escaping () -> Void, image: Image, scale: Bool = true, frame: CGSize? = nil) {
        self._condition = .constant(false)
        self.perform = perform
        self.image = image
        self.scale = scale
        self.frame = frame
    }
    
    var body: some View {
        Group {
            if frame != nil {
                frameButton
            } else {
                framelessButton
            }
        }
    }

    private var frameButton: some View {
        Group {
            if scale {
                defaultButtonWithFrame
                    .buttonStyle(ScaleButtonStyle())
            } else {
                defaultButtonWithFrame
            }
        }
    }

    private var defaultButtonWithFrame: some View {
        Button(action: {
            withAnimation {
                self.condition.toggle()
                self.perform()
            }
        }) {
            image
                .resizable()
                .frame(width: frame!.width, height: frame!.height)
        }
    }

    private var framelessButton: some View {
        Group {
            if scale {
                defaultButtonWithoutFrame
                    .buttonStyle(ScaleButtonStyle())
            } else {
                defaultButtonWithoutFrame
            }
        }
    }

    private var defaultButtonWithoutFrame: some View {
        Button(action: {
            withAnimation {
                self.condition.toggle()
                self.perform()
            }
        }) {
            image
                .imageScale(.large)
        }
    }
}

struct BImage_Previews: PreviewProvider {
    static var previews: some View {
        BImage(condition: .constant(false), image: .init(systemName: "arrow.left")).previewLayout(.sizeThatFits)
    }
}
