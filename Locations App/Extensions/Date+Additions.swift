//
//  Date+Additions.swift
//  Locations App
//
//  Created by Kevin Li on 1/30/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import Foundation

extension Date {
    var timeOnlyNoPadding: String {
        return Formatter.timeOnlyNoPadding.string(from: self)
    }
}
