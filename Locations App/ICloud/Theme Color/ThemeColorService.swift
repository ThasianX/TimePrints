import SwiftUI

protocol ThemeColorService {
    var isInitialThemeSetup: Bool { get }
    var themeColor: String { get }
    
    func setThemeColor(hexString: String)
    func finalizeThemeSetup()
}

final class MockIsSetThemeColorService: ThemeColorService {
    var isInitialThemeSetup: Bool = true
    var themeColor: String = UIColor.persianPink.hexString()

    func setThemeColor(hexString: String) { }

    func finalizeThemeSetup() { }
}

final class MockIsNotSetThemeColorService: ThemeColorService {
    var isInitialThemeSetup: Bool = false
    var themeColor: String = ""

    func setThemeColor(hexString: String) {
        themeColor = hexString
    }

    func finalizeThemeSetup() {
        isInitialThemeSetup = true
    }
}

