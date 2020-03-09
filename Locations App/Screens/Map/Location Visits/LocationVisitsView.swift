import SwiftUI

struct LocationVisitsView: View {
    @FetchRequest var visitsForSelectedLocation: FetchedResults<Visit>

    @ObservedObject var mapState: MapState
    @Binding var showingToggleButton: Bool
    
    init(mapState: MapState, showingToggleButton: Binding<Bool>) {
        self.mapState = mapState
        self._showingToggleButton = showingToggleButton
        
        let locationExists = mapState.selectedLocation != nil
        self._visitsForSelectedLocation = FetchRequest(
            entity: Visit.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Visit.arrivalDate, ascending: false)
            ],
            predicate: locationExists ? NSPredicate(format: "%@ == location", mapState.selectedLocation!) : nil
        )
    }
    
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
        Text("Visits for \(mapState.selectedLocation?.name ?? "")")
            .font(.headline)
    }
    
    private var locationVisitsList: some View {
        VStack(spacing: 8) {
            ForEach(visitsForSelectedLocation) { visit in
                LocationVisitsRow(visit: visit)
            }
        }
    }
    
    private var exitButton: some View {
        BImage(perform: exitView, image: .init(systemName: "x.circle.fill"))
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

private extension LocationVisitsView {
    private func exitView() {
        mapState.showingLocationVisits = false
        showingToggleButton = true
    }
}

struct LocationVisitsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationVisitsView(mapState: .init(), showingToggleButton: .constant(false)).environment(\.managedObjectContext, CoreData.stack.context)
    }
}
