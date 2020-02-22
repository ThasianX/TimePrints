import SwiftUI

struct LocationVisitsView: View {
    @FetchRequest var visitsForSelectedLocation: FetchedResults<Visit>
    
    @Binding var show: Bool
    
    let selectedLocation: Location?
    
    init(show: Binding<Bool>, selectedLocation: Location?) {
        self._show = show
        self.selectedLocation = selectedLocation
        
        let locationExists = selectedLocation != nil
        self._visitsForSelectedLocation = FetchRequest(
            entity: Visit.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Visit.arrivalDate, ascending: false)
            ],
            predicate: locationExists ? NSPredicate(format: "%@ == location", selectedLocation!) : nil
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
        Text("Visits for \(selectedLocation?.name ?? "")")
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
        BImage(perform: dontShow, image: .init(systemName: "x.circle.fill"))
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
    private func dontShow() {
        self.show = false
    }
}

struct LocationVisitsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationVisitsView(show: .constant(true), selectedLocation: .preview).environment(\.managedObjectContext, CoreData.stack.context)
    }
}
