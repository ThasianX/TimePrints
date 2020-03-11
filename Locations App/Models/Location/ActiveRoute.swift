import SwiftUI

class ActiveRoute: ObservableObject {
    private var locations: [Location] = []
    private var locationIndex: Int = 0

    var exists: Bool {
        !locations.isEmpty
    }

    var currentLocation: Location {
        locations[locationIndex]
    }

    func setLocations(locations: [Location]) {
        self.locations = locations
        objectWillChange.send()
    }

    var isAtEnd: Bool {
        locationIndex == locations.count-1
    }

    func selectNextLocation() {
        locationIndex += 1
        objectWillChange.send()
    }

    func restart() {
        locationIndex = 0
        objectWillChange.send()
    }

    func reset() {
        locations = []
        locationIndex = 0
        objectWillChange.send()
    }
}
