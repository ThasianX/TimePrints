import Foundation

final class ICloudThemeColorService: ThemeColorService {
    var isThemeColorSet: Bool {
        ICloudKVS.Account.bool(forKey: .isThemeColorSet)
    }

    func setThemeColor(hex: String) {
        ICloudKVS.Account.set(true, for: .isThemeColorSet)
        ICloudKVS.Account.set(hex, for: .themeColor)
    }
}
