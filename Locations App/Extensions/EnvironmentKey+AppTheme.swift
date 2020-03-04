import SwiftUI

struct AppThemeKey: EnvironmentKey {
    static let defaultValue: UIColor = .clear
}

extension EnvironmentValues {
    var appTheme: UIColor {
        get {
            self[AppThemeKey.self]
        }
        set {
            self[AppThemeKey.self] = newValue
        }
    }
}
