import SwiftUI

protocol ThemeColorService {
    var isThemeColorSet: Bool { get }
    func setThemeColor(hex: String)
}

final class MockIsSetThemeColorService: ThemeColorService {
    var isThemeColorSet: Bool = true

    func setThemeColor(hex: String) { }
}

final class MockIsNotSetThemeColorService: ThemeColorService {
    var isThemeColorSet: Bool = false

    func setThemeColor(hex: String) {
        isThemeColorSet = true
    }
}

