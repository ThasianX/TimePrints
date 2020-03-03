// Kevin Li - 12:20 AM - 2/29/20

import Foundation

protocol KeyNamespaceable { }

extension KeyNamespaceable {
    private static func namespace(_ key: String) -> String {
        "\(Self.self).\(key)"
    }
    
    static func namespace<T: RawRepresentable>(_ key: T) -> String where T.RawValue == String {
        namespace(key.rawValue)
    }
}
