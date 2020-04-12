import Foundation
import SwiftUI

protocol TagProvider {
    var normalTagColor: Color { get }
    var selectedLocation: Location? { get }
}
