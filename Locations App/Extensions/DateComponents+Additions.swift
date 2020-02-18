import Foundation

extension DateComponents: Comparable {
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        Calendar.current.date(from: lhs) ?? Date.distantFuture < Calendar.current.date(from: rhs) ?? Date.distantFuture
    }
}

extension DateComponents: Identifiable {
    public var id: Date {
        self.date
    }
}

extension DateComponents {
    var date: Date {
        Calendar.current.date(from: self) ?? Date.distantFuture
    }
    
    var monthAndYear: DateComponents {
        return DateComponents(year: self.year, month: self.month)
    }
}
