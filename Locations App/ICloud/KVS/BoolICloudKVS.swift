// Kevin Li - 12:19 AM - 2/29/20

import Foundation

typealias ICloudKVS = NSUbiquitousKeyValueStore

protocol BoolICloudKVS: KeyNamespaceable {
    associatedtype BoolICloudKey: RawRepresentable
}

extension BoolICloudKVS where BoolICloudKey.RawValue == String {
    static func set(_ value: Bool, for key: BoolICloudKey) {
        let key = namespace(key)
        ICloudKVS.default.set(value, forKey: key)
    }

    static func bool(forKey key: BoolICloudKey) -> Bool {
        let key = namespace(key)
        return ICloudKVS.default.bool(forKey: key)
    }
}
