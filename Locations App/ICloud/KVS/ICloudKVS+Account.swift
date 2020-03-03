// Kevin Li - 12:22 AM - 2/29/20

import Foundation

extension NSUbiquitousKeyValueStore {
    struct Account: AccountKVS {
        enum AccountKey: String {
            case isUserLoggedIn
            case isThemeColorSet
            case themeColor
        }
    }
}
