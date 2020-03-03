import Foundation

final class ICloudThemeColorService: ThemeColorService {
    var isInitialThemeSetup: Bool {
        ICloudKVS.Account.bool(forKey: .isInitialThemeSetup)
    }

    var themeColor: String {
        ICloudKVS.Account.string(forKey: .themeColor)!
    }

    func setThemeColor(hexString: String) {
        ICloudKVS.Account.set(hexString, for: .themeColor)
    }

    func finalizeThemeSetup() {
        ICloudKVS.Account.set(true, for: .isInitialThemeSetup)
    }
}
