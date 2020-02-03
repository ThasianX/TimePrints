//
//  Location.swift
//  Locations App
//
//  Created by Kevin Li on 2/3/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import Foundation
import MapKit

struct Location {
    let name: String
    let address: String
}

extension Location: Hashable { }
