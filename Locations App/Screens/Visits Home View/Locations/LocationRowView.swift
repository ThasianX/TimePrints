// Kevin Li - 6:35 PM - 5/16/20

import SwiftUI

struct LocationRowView: View {
    let location: Location
    let locationService: LocationService
    let setActiveLocationAndDisplayMap: (Location) -> Void

    var body: some View {
        locationRowView
            .onTapGesture(perform: onTap)
    }

    private var locationRowView: some View {
        HStack {
            VStack(alignment: .leading) {
                locationNameText
                locationDetailsText
            }
            Spacer()
            distanceFromCurrentLocationText
        }
        .padding(6)
    }
}

private extension LocationRowView {
    private func onTap() {
        setActiveLocationAndDisplayMap(location)
    }
}

private extension LocationRowView {
    private var locationNameText: some View {
        Text(location.name)
            .font(.headline)
    }

    private var locationDetailsText: some View {
        Text("\(numberOfVisits), \(visitDateRange)")
            .font(.caption)
            .foregroundColor(.secondary)
    }

    private var numberOfVisits: String {
        "\(location.visits.count) \(location.visits.count > 1 ? "visits" : "visit")"
    }

    private var visitDateRange: String {
        let sortedVisits = location.visits.sorted(by: { $0.arrivalDate < $1.arrivalDate })

        guard let earliestVisit = sortedVisits.first else {
            return ""
        }

        let earliestVisitDateString = earliestVisit.arrivalDate.abbreviatedMonthWithDayAndYear

        guard sortedVisits.count > 1, let latestVisit = sortedVisits.last else {
            return earliestVisitDateString
        }

        let latestVisitDateString = latestVisit.arrivalDate.abbreviatedMonthWithDayAndYear
        return "\(earliestVisitDateString) - \(latestVisitDateString)"
    }

    private var distanceFromCurrentLocationText: some View {
        Text(distanceFromCurrentLocation)
            .font(.subheadline)
            .foregroundColor(.secondary)
    }

    private var distanceFromCurrentLocation: String {
        return locationService.distanceFromCurrentLocation(location: location)
    }
}

struct LocationRowView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRowView(location: .preview, locationService: MockLocationService(), setActiveLocationAndDisplayMap: { _ in })
            .background(Color.pink)
            .previewLayout(.sizeThatFits)
    }
}
