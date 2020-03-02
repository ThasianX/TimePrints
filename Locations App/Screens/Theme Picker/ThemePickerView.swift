// Kevin Li - 10:42 AM - 3/2/20

import SwiftUI

struct ThemePickerView: View {
    @State private var selectedIndex = 0

    let themeColors = AppColors.themes

    private var selectedColor: Color {
        Color(themeColors[selectedIndex])
    }

    var body: some View {
        ZStack {
            ColorAdaptiveVisitsView(color: selectedColor)
                .animation(.easeInOut)
            ScalingCircle(selectedIndex: $selectedIndex, index: 1, color: Color(themeColors[1]))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5))
                .extendToScreenEdges()
        }
    }
}

struct ThemePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePickerView()
    }
}
