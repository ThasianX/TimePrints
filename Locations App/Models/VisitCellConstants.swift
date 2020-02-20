import Foundation
import UIKit

struct VisitCellConstants {
    static let height: CGFloat = 80
    static let width: CGFloat = screen.width - 60

    static func height(if isSelected: Bool) -> CGFloat {
        isSelected ? screen.height : height
    }

    static func maxWidth(if isSelected: Bool) -> CGFloat {
        isSelected ? .infinity : width
    }
}
