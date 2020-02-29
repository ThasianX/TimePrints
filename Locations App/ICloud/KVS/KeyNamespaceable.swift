// Kevin Li - 12:20 AM - 2/29/20

import Foundation

protocol KeyNamespaceable { }

extension KeyNamespaceable {
    static func namespace<T>(_ key: T) -> String where T: RawRepresentable {
        "\(Self.self).\(key.rawValue)"
    }
}
