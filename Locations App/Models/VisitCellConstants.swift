import Foundation
import UIKit

struct VisitCellConstants {
    static let height: CGFloat = 80
    static let width: CGFloat = screen.width - 60

    static func height(if isSelected: Bool) -> CGFloat {
        isSelected.when(true: screen.height, false: VisitCellConstants.height)
    }

    static func maxWidth(if isSelected: Bool) -> CGFloat {
        isSelected.when(true: .infinity, false: VisitCellConstants.width)
    }
}
