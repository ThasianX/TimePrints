//
//  DateFormatter+Additions.swift
//  Locations App
//
//  Created by Kevin Li on 1/30/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import Foundation

extension Formatter {
    static let timeOnlyWithPadding: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    static let abbreviatedDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()
    
    static let dayOfMonth: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    static let fullMonthWithYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM y"
        return formatter
    }()
}
