// Kevin Li - 10:42 AM - 3/2/20

import SwiftUI

struct ThemePickerView: View {
    @State private var selectedColor = AppColors.themes[0]

    let themeColors = AppColors.themes.chunked(into: 2)

    var body: some View {
        ZStack {
            ColorAdaptiveVisitsView(color: selectedColor.color)
                .animation(.easeInOut)
            colorPickerList
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5))
                .extendToScreenEdges()
        }
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
    }
}

struct ThemePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePickerView()
    }
}
