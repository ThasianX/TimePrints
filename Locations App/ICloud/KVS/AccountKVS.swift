// Kevin Li - 12:19 AM - 2/29/20

import Foundation

typealias ICloudKVS = NSUbiquitousKeyValueStore

protocol AccountKVS: KeyNamespaceable {
    associatedtype AccountKey: RawRepresentable
}

extension AccountKVS where AccountKey.RawValue == String {
    static func set(_ value: Bool, for key: AccountKey) {
        ICloudKVS.default.set(value, forKey: namespace(key))
    }

    static func bool(forKey key: AccountKey) -> Bool {
        ICloudKVS.default.bool(forKey: namespace(key))
    }

    static func set(_ value: String, for key: AccountKey) {
        ICloudKVS.default.set(value, forKey: namespace(key))
    }

    static func string(forKey key: AccountKey) -> String? {
        ICloudKVS.default.string(forKey: namespace(key))
    }
}
