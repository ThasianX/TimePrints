import Foundation

enum MapState: Equatable {
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

    var selectedLocation: Location {
        switch self {
        case let .showingEditTag(location), let .showingLocationVisits(location):
            return location
        case .showingMap:
            fatalError("Should not be calling `selectedLocation` when the map is showing")
        }
    }
}
