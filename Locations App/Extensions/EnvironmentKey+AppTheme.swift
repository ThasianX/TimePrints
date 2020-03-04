import SwiftUI

struct AppThemeKey: EnvironmentKey {
    static let defaultValue: Color = .clear
}

extension EnvironmentValues {
    var appTheme: Color {
        get {
            self[AppThemeKey.self]
        }
        set {
            self[AppThemeKey.self] = newValue
        }
    }
}
