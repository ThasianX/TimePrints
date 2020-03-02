import Foundation

extension Dictionary where Key: Comparable {
    var ascendingKeys: [Key] {
        get {
            keys.sorted(by: { $0 < $1 })
        }
    }
    
    var descendingKeys: [Key] {
        get {
            keys.sorted(by: { $0 > $1 })
        }
    }
}

extension Dictionary where Value: Equatable {
    func key(for value: Value) -> Key? {
        first(where: { $1 == value })?.key
    }
}
