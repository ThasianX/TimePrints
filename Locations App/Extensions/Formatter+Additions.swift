//
//  DateFormatter+Additions.swift
//  Locations App
//
//  Created by Kevin Li on 1/30/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import Foundation

extension Formatter {
    static let timeOnlyNoPadding: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:m a"
        return formatter
    }()
}
