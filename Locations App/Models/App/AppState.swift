// Kevin Li - 10:15 PM - 3/15/20

import SwiftUI

class AppState: ObservableObject {
    @Published var showing: Showing = .init()
    @Published var locationControl: LocationControl = .init()
    @Published var route: Route = .init()
}

extension AppState {
    struct Showing {
        var toggleButton: Bool = true
        var homeView: Bool = false
    }
}

extension AppState {
    struct LocationControl {
        var stayAtCurrent: Bool = false
        var activeForVisit: Location? = nil

        mutating func reset(stayAtCurrent: Bool) {
            self.stayAtCurrent = stayAtCurrent
            activeForVisit = nil
        }
    }
}

extension AppState {
    struct Route {
        fileprivate var visits: [Visit] = []
        fileprivate var visitsIndex: Int = 0

        var exists: Bool {
            !visits.isEmpty
        }

        var currentVisit: Visit {
            visits[visitsIndex]
        }

        var currentLocation: Location {
            currentVisit.location
        }

        var isAtEnd: Bool {
            visitsIndex == visits.count-1
        }

        mutating func setVisits(visits: [Visit]) {
            self.visits = visits
        }

        mutating func selectNextLocation() {
            visitsIndex += 1
        }

        mutating func restart() {
            visitsIndex = 0
        }

        mutating func reset() {
            visits = []
            visitsIndex = 0
        }
    }
}
