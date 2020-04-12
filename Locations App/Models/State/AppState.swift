// Kevin Li - 10:15 PM - 3/15/20

import Mapbox
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
    struct Route: TagProvider {
        fileprivate var visits: [Visit]
        fileprivate var visitsIndex: Int = 0

        var isCentered = true

        init(visits: [Visit] = []) {
            self.visits = visits
        }

        var exists: Bool {
            !visits.isEmpty
        }

        var currentVisit: Visit {
            visits[visitsIndex]
        }

        var currentLocation: Location {
            currentVisit.location
        }

        var isAtStart: Bool {
            visitsIndex == 0
        }

        var isAtEnd: Bool {
            visitsIndex == visits.count-1
        }

        var date: Date {
            visits.first!.arrivalDate
        }

        var currentIndex: Int {
            visitsIndex
        }

        var length: Int {
            visits.count
        }

        mutating func setVisits(visits: [Visit]) {
            self.visits = visits
            isCentered = true
        }

        mutating func selectPreviousLocation() {
            visitsIndex -= 1
            isCentered = true
        }

        mutating func selectNextLocation() {
            visitsIndex += 1
            isCentered = true
        }

        mutating func recenter() {
            let index = visitsIndex
            visitsIndex = index
            isCentered = true
        }

        mutating func reset() {
            visits = []
            visitsIndex = 0
        }

        var normalTagColor: Color {
            selectedLocation!.accent.color
        }

        var selectedLocation: Location? {
            currentVisit.location
        }
    }
}
