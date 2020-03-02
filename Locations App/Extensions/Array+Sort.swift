import Foundation

extension Array where Element: Comparable {
    var sortAscending: Array {
        sorted(by: { $0 < $1 })
    }
    
    var sortDescending: Array {
        sorted(by: { $0 > $1 })
    }
}

extension Array where Element: Visit {
    var sortAscByArrivalDate: Array {
        sorted(by: { $0.arrivalDate < $1.arrivalDate })
    }
}
