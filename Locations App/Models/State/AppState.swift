// Kevin Li - 10:15 PM - 3/15/20

import Combine
import Mapbox
import SwiftUI

class AppState: ObservableObject {
    @Published var showing: Showing = .init()
    @Published var locationControl: LocationControl = .init()
    @Published var route: Route = .init()

    var anyCancellable = Set<AnyCancellable>()

    init() {
        showing.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }.store(in: &anyCancellable)

        locationControl.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }.store(in: &anyCancellable)

        route.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }.store(in: &anyCancellable)
    }
}

extension AppState {
    class Showing: ObservableObject {
        @Published var toggleButton: Bool = true
        @Published var homeView: Bool = false
    }
}

extension AppState {
    class LocationControl: ObservableObject {
        @Published var stayAtCurrent: Bool = false
        @Published var activeForVisit: Location? = nil

        func reset(stayAtCurrent: Bool) {
            self.stayAtCurrent = stayAtCurrent
            activeForVisit = nil
        }
    }
}

extension AppState {
    class Route: TagProvider, ObservableObject {
        @Published private var visits: [Visit]
        @Published private var visitsIndex: Int = 0

        @Published var isCentered = true

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

        func setVisits(visits: [Visit]) {
            self.visits = visits
            isCentered = true
        }

        func selectPreviousLocation() {
            visitsIndex -= 1
            isCentered = true
        }

        func selectNextLocation() {
            visitsIndex += 1
            isCentered = true
        }

        func recenter() {
            let index = visitsIndex
            visitsIndex = index
            isCentered = true
        }

        func reset() {
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
