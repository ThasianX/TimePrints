import SwiftUI

struct SetupThemePickerView: View {
    let defaultThemeColor: UIColor
    let onSelected: (UIColor) -> Void
    let onFinalize: () -> Void

    var body: some View {
        themePickerViewWithButton
    }

    private var themePickerViewWithButton: some View {
        ZStack(alignment: .topTrailing) {
            themePickerView
            transitionToAppButton
                .padding(.top)
                .padding(.trailing, 35)
        }
    }

    private var themePickerView: ThemePickerView {
        ThemePickerView(startingThemeColor: defaultThemeColor, onSelected: onSelected)
    }

    private var transitionToAppButton: DimensionalButton {
        DimensionalButton(image: Image(systemName: "arrow.right"), action: onFinalize, circleColor: UIColor.kingFisherDaisy.color)
    }
}

struct SetupThemePickerView_Previews: PreviewProvider {
    static var previews: some View {
        SetupThemePickerView(defaultThemeColor: AppColors.themes.first!, onSelected: { _ in }, onFinalize: { })
    }
}
