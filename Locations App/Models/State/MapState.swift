import Foundation
import SwiftUI

enum MapState: Equatable, TagProvider {
    case showingMap
    case showingEditTag(Location)
    case showingLocationVisits(Location)

    var isShowingMap: Bool {
        self == .showingMap
    }

    var isShowingEditTag: Bool {
        if case .showingEditTag(_) = self {
            return true
        }
        return false
    }

    var isshowingLocationVisits: Bool {
        if case .showingLocationVisits(_) = self {
            return true
        }
        return false
    }

    var hasSelectedLocation: Bool {
        switch self {
        case .showingEditTag, .showingLocationVisits:
            return true
        case .showingMap:
            return false
        }
    }

    var normalTagColor: Color {
        hasSelectedLocation ? selectedLocation!.accent.color : .clear
    }

    var selectedLocation: Location? {
        switch self {
        case let .showingEditTag(location), let .showingLocationVisits(location):
            return location
        case .showingMap:
            return nil
        }
    }
}
