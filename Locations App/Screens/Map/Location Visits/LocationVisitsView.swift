import SwiftUI

private enum EditingState: Equatable {
    case normal
    case editingLocationName

    var isNormal: Bool {
        self == .normal
    }

    var isEditingLocationName: Bool {
        self == .editingLocationName
    }
}

struct LocationVisitsView: View {
    @Environment(\.appTheme) private var appTheme: UIColor

    @State private var editingState: EditingState = .normal

    @Binding var mapState: MapState
    @Binding var showing: AppState.Showing

    private var currentLocation: Location {
        mapState.selectedLocation!
    }

    var body: some View {
        VStack(spacing: 8) {
            Group {
                if mapState.hasSelectedLocation {
                    locationNameTextField
                }
                if mapState.hasSelectedLocation {
                    locationVisitsList
                }
                Spacer()
                exitButton
            }
            .transition(.move(edge: .bottom))
        }
        .padding()
        .animation(.spring())
    }
}

private extension LocationVisitsView {
    private var locationNameTextField: some View {
        LocationNameTextField(
            location: currentLocation,
            textColor: appTheme.color,
            onEditingChanged: setEditingStateForLocationName)
    }

    private func setEditingStateForLocationName(_ isEditing: Bool) {
        editingState = isEditing ? .editingLocationName : .normal
    }

    private var locationVisitsList: some View {
        FilteredList(predicate: visitsPredicate, sortDescriptors: [arrivalDateSort], spacing: 8) { (visit: Visit) in
            LocationVisitsRow(visit: visit)
        }
    }

    private var visitsPredicate: NSPredicate {
        NSPredicate(format: "%@ == location", mapState.selectedLocation!)
    }

    private var arrivalDateSort: NSSortDescriptor {
        NSSortDescriptor(keyPath: \Visit.arrivalDate, ascending: false)
    }
    
    private var exitButton: some View {
        BImage(perform: exitView, image: .init(systemName: "x.circle.fill"))
    }
    
    private func exitView() {
        mapState = .showingMap
        showing.toggleButton = true
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
}

struct LocationVisitsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationVisitsView(mapState: .constant(.showingLocationVisits(.preview)), showing: .constant(.init()))
            .environment(\.managedObjectContext, CoreData.stack.context)
    }
}
