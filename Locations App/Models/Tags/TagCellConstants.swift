// Kevin Li - 8:49 PM - 4/18/20 - macOS 10.15

import Foundation
import UIKit

struct TagCellConstants {
    static let height: CGFloat = 75

    static func height(if isSelected: Bool) -> CGFloat {
        isSelected ? screen.height : height
    }

    static func maxWidth(if isSelected: Bool) -> CGFloat? {
        isSelected ? .infinity : nil
    }
}
