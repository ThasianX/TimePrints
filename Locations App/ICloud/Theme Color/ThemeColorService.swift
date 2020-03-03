import SwiftUI

protocol ThemeColorService {
    var isThemeColorSet: Bool { get }
    var themeColor: String { get }
    
    func setThemeColor(hexString: String)
}

final class MockIsSetThemeColorService: ThemeColorService {
    var isThemeColorSet: Bool = true
    var themeColor: String = UIColor.persianPink.hexString()

    func setThemeColor(hexString: String) { }
}

final class MockIsNotSetThemeColorService: ThemeColorService {
    var isThemeColorSet: Bool = false
    var themeColor: String = ""

    func setThemeColor(hexString: String) {
        themeColor = hexString
        isThemeColorSet = true
    }
}

