// Kevin Li - 10:42 AM - 3/2/20

import SwiftUI

struct ThemePickerView: View {
    @State private var selectedColor: UIColor = .clear
    let startingThemeColor: UIColor
    let onSelected: (UIColor) -> Void

    let themeColors = AppColors.themes.chunked(into: 2)

    init(hexString: String?, onSelected: @escaping (UIColor) -> Void) {
        if let hexString = hexString {
            startingThemeColor = UIColor(hexString)
        } else {
            startingThemeColor = AppColors.themes.first!
        }

        self.onSelected = onSelected
    }

    var body: some View {
        ZStack {
            ColorAdaptiveVisitsView(color: selectedColor.color)
                .frame(maxHeight: screen.height)
                .animation(.easeInOut)
            colorPickerList
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5))
                .extendToScreenEdges()
        }
        .onAppear(perform: setSelectedThemeWithAnimation)
    }

    private func setSelectedThemeWithAnimation() {
        selectedColor = startingThemeColor
    }
}

private extension ThemePickerView {
    private var colorPickerList: some View {
        colorPickerStack
            .frame(width: screen.width)
            .padding()
    }

    private var colorPickerStack: some View {
        VStack(spacing: 50) {
            ForEach(themeColors, id: \.self) { rowUiColors in
                HStack {
                    self.scalingCircleView(for: rowUiColors[0])
                    self.scalingCircleView(for: rowUiColors[1])
                }
            }
        }
    }

    private func scalingCircleView(for uiColor: UIColor) -> some View {
        ScalingCircle(selectedColor: $selectedColor, uiColor: uiColor)
            .onTapGesture {
                self.onSelected(uiColor)
        }
    }
}

struct ThemePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePickerView(hexString: nil, onSelected: { _ in })
    }
}
