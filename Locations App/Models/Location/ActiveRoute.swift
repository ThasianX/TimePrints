import SwiftUI

class ActiveRoute: ObservableObject {
    private var visits: [Visit] = []
    private var visitsIndex: Int = 0

    var exists: Bool {
        !visits.isEmpty
    }

    var currentVisit: Visit {
        visits[visitsIndex]
    }

    func setVisits(visits: [Visit]) {
        self.visits = visits
        objectWillChange.send()
    }

    var isAtEnd: Bool {
        visitsIndex == visits.count-1
    }

    func selectNextLocation() {
        visitsIndex += 1
        objectWillChange.send()
    }

    func restart() {
        visitsIndex = 0
        objectWillChange.send()
    }

    func reset() {
        visits = []
        visitsIndex = 0
        objectWillChange.send()
    }
}
