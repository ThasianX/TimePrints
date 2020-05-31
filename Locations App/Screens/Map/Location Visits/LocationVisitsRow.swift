// Kevin Li - 9:09 PM - 5/30/20

import SwiftUI

struct LocationVisitsRow: View {
    let visit: Visit

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                arrivalDateAbbreviatedText
                Spacer()
                if visit.isFavorite {
                    starImage
                }
            }
            visitDurationText
            if !visit.notes.isEmpty {
                visitNotes
            }
        }
        .padding(.vertical, 4)
    }

    private var arrivalDateAbbreviatedText: some View {
        Text(visit.arrivalDate.abbreviatedMonthWithDayAndYear)
            .font(.headline)
    }

    private var starImage: some View {
        Image(systemName: "star.fill")
            .imageScale(.medium)
            .foregroundColor(.yellow)
    }

    private var visitDurationText: some View {
        Text(visit.duration)
            .font(.subheadline)
    }

    private var visitNotes: some View {
        Text(visit.notes)
            .font(.caption)
            .lineLimit(2)
    }
}
