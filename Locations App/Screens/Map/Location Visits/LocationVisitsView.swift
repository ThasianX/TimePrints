import SwiftUI

struct LocationVisitsView: View {
    @Binding var mapState: MapState
    @Binding var showingToggleButton: Bool
    
    var body: some View {
        VStack {
            headerText
                .padding(.bottom, 8)

            locationVisitsList
            Spacer()
            exitButton
        }
        .padding()
    }
}

private extension LocationVisitsView {
    private var headerText: some View {
        let name = mapState.hasSelectedLocation ? mapState.selectedLocation.name : ""
        return Text("Visits for \(name)")
            .font(.headline)
    }
    
    private var locationVisitsList: some View {
        Group {
            if mapState.hasSelectedLocation {
                FilteredList(predicate: visitsPredicate, sortDescriptors: [arrivalDateSort], spacing: 8) { (visit: Visit) in
                    LocationVisitsRow(visit: visit)
                }
            }
        }
    }

    private var visitsPredicate: NSPredicate {
        NSPredicate(format: "%@ == location", mapState.selectedLocation)
    }

    private var arrivalDateSort: NSSortDescriptor {
        NSSortDescriptor(keyPath: \Visit.arrivalDate, ascending: false)
    }
    
    private var exitButton: some View {
        BImage(perform: exitView, image: .init(systemName: "x.circle.fill"))
    }
    
    private func exitView() {
        mapState = .showingMap
        showingToggleButton = true
    }
}

private extension LocationVisitsView {
    private struct LocationVisitsRow: View {
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
            Text(visit.visitDuration)
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
}

struct LocationVisitsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationVisitsView(mapState: .constant(.showingLocationVisits(.preview)), showingToggleButton: .constant(false)).environment(\.managedObjectContext, CoreData.stack.context)
    }
}
