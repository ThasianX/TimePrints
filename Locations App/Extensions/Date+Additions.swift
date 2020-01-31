//
//  Date+Additions.swift
//  Locations App
//
//  Created by Kevin Li on 1/30/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import Foundation

extension Date {
    var timeOnlyWithPadding: String {
        return Formatter.timeOnlyWithPadding.string(from: self)
    }
    
    var abbreviatedDay: String {
        return Formatter.abbreviatedDay.string(from: self)
    }
    
    var dayOfMonth: String {
        return Formatter.dayOfMonth.string(from: self)
    }
    
    var fullMonthWithYear: String {
        return Formatter.fullMonthWithYear.string(from: self)
    }
}

extension Date {
    var dateComponents: DateComponents {
        Calendar.current.dateComponents([.day, .month, .year], from: self)
    }
}
