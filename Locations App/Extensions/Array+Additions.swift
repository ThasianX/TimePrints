//
//  Array+Additions.swift
//  Locations App
//
//  Created by Kevin Li on 1/31/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import Foundation

extension Array where Element: Comparable {
    var sortAscending: Array {
        sorted(by: { $0 < $1 })
    }
    
    var sortDescending: Array {
        sorted(by: { $0 > $1 })
    }
}
