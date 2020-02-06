//
//  UIColorInputError.swift
//  Locations App
//
//  Created by Kevin Li on 2/2/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import Foundation

public enum UIColorInputError: Error {
    
    case missingHashMarkAsPrefix(String)
    case unableToScanHexValue(String)
    case mismatchedHexStringLength(String)
    case unableToOutputHexStringForWideDisplayColor
}

extension UIColorInputError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .missingHashMarkAsPrefix(let hex):
            return "Invalid RGB string, missing '#' as prefix in \(hex)"
            
        case .unableToScanHexValue(let hex):
            return "Scan \(hex) error"
            
        case .mismatchedHexStringLength(let hex):
            return "Invalid RGB string from \(hex), number of characters after '#' should be either 3, 4, 6 or 8"
            
        case .unableToOutputHexStringForWideDisplayColor:
            return "Unable to output hex string for wide display color"
        }
    }
}
