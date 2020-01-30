//
//  NSPredicate+Additions.swift
//  Locations App
//
//  Created by Kevin Li on 1/29/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import Foundation

extension NSPredicate {
    static var withinCurrentDate: NSPredicate {
        let calendar = Calendar.current
        let date = Date()
        let dateFrom = calendar.startOfDay(for: date)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: date)!
        let fromPredicate = NSPredicate(format: "%@ >= %@", date as NSDate, dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "%@ <= %@", date as NSDate, dateTo as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        return datePredicate
    }
}
