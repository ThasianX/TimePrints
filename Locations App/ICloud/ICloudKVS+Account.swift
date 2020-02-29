// Kevin Li - 12:22 AM - 2/29/20

import Foundation

extension NSUbiquitousKeyValueStore {
    struct Account: BoolICloudKVS {
        enum BoolICloudKey: String {
            case isUserLoggedIn
        }
    }
}
