import Foundation

extension Date {
    var timeOnlyWithPadding: String {
        return Formatter.timeOnlyWithPadding.string(from: self)
    }
    
    var abbreviatedDayOfWeek: String {
        return Formatter.abbreviatedDayOfWeek.string(from: self)
    }
    
    var fullDayOfWeek: String {
        return Formatter.fullDayOfWeek.string(from: self)
    }
    
    var dayOfMonth: String {
        return Formatter.dayOfMonth.string(from: self)
    }
    
    var fullMonthWithYear: String {
        return Formatter.fullMonthWithYear.string(from: self)
    }
    
    var fullMonthWithDay: String {
        return Formatter.fullMonthWithDay.string(from: self)
    }
    
    var fullMonthWithDayOfWeek: String {
        return Formatter.fullMonthWithDayOfWeek.string(from: self)
    }
    
    var abbreviatedMonthWithDayAndYear: String {
        return Formatter.abbreviatedMonthWithDayAndYear.string(from: self)
    }
    
    var fullMonthWithDayAndYear: String {
        return Formatter.fullMonthWithDayAndYear.string(from: self)
    }
}

extension Date {
    var dateComponents: DateComponents {
        Calendar.current.dateComponents([.day, .month, .year], from: self)
    }
}

extension Date {
    static func random(range: Int) -> Date {
        let interval = Date().timeIntervalSince1970
        let intervalRange = Double(86_400 * range)
        let random = Double(arc4random_uniform(UInt32(intervalRange)) + 1)
        let newInterval = interval + (random - (intervalRange / 2.0))
        return Date(timeIntervalSince1970: newInterval)
    }
    
    var dayOfWeekBasedOnCurrentDay: String {
        let day: String
        if Calendar.current.isDateInToday(self) {
            day = "Today"
        } else if Calendar.current.isDateInYesterday(self) {
            day = "Yesterday"
        } else if Calendar.current.isDateInTomorrow(self) {
            day = "Tomorrow"
        } else {
            day = self.fullDayOfWeek
        }
        return day
    }
}
