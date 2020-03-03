import Foundation

final class ICloudThemeColorService: ThemeColorService {
    var isThemeColorSet: Bool {
        ICloudKVS.Account.bool(forKey: .isThemeColorSet)
    }

    var themeColor: String {
        ICloudKVS.Account.string(forKey: .themeColor)!
    }

    func setThemeColor(hexString: String) {
        ICloudKVS.Account.set(true, for: .isThemeColorSet)
        ICloudKVS.Account.set(hexString, for: .themeColor)
    }
}
