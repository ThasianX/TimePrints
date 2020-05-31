import Foundation

extension Formatter {
    static let timeOnlyWithPadding: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    static let abbreviatedDayOfWeek: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()
    
    static let fullDayOfWeek: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    static let dayOfMonth: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()

    static let abbreviatedMonthWithYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM y"
        return formatter
    }()
    
    static let fullMonthWithYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM y"
        return formatter
    }()
    
    static let fullMonthWithDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter
    }()
    
    static let fullMonthWithDayOfWeek: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMMM d"
        return formatter
    }()

    static let abbreviatedMonthWithDayAndYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, y"
        return formatter
    }()
    
    static let fullMonthWithDayAndYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, y"
        return formatter
    }()
}
