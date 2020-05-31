// Kevin Li - 9:09 PM - 5/30/20

import SwiftUI

struct LocationVisitsRow: View {
    let visit: Visit

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                visitDurationText
                Spacer()
                starImageIfFavorited
            }
            arrivalDateAbbreviatedText
        }
    }

    private var visitDurationText: some View {
        Text(visit.duration)
    }

    private var starImageIfFavorited: some View {
        Group {
            if visit.isFavorite {
                Image(systemName: "star.fill")
                    .imageScale(.medium)
                    .foregroundColor(.yellow)
            }
        }
    }

    private var arrivalDateAbbreviatedText: some View {
        Text(visit.arrivalDate.abbreviatedMonthWithDayAndYear)
            .font(.caption)
    }
}
