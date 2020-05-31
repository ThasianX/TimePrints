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
        VStack {
            Group {
                if mapState.hasSelectedLocation {
                    headerView
                        .padding(.bottom)
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

extension LocationVisitsView {
    private var headerView: some View {
        V0Stack {
            locationNameTextField
            locationVisitsAddressText
        }
    }

    private var locationNameTextField: some View {
        LocationNameTextField(
            location: currentLocation,
            textColor: appTheme.color,
            onEditingChanged: setEditingStateForLocationName)
    }

    private func setEditingStateForLocationName(_ isEditing: Bool) {
        editingState = isEditing ? .editingLocationName : .normal
    }

    private var locationVisitsAddressText: some View {
        Text(currentLocation.address)
            .font(.caption)
    }
}

extension LocationVisitsView {
    private var locationVisitsList: some View {
        FilteredListView(
            sortDescriptors: [arrivalDateSort],
            predicate: visitsPredicate,
            content: LocationVisitsRow.init)
    }

    private var arrivalDateSort: NSSortDescriptor {
        NSSortDescriptor(keyPath: \Visit.arrivalDate, ascending: false)
    }

    private var visitsPredicate: NSPredicate {
        NSPredicate(format: "%@ == location", mapState.selectedLocation!)
    }
}

private extension LocationVisitsView {
    var exitButton: some View {
        BImage(perform: exitView, image: .init(systemName: "x.circle.fill"))
    }

    func exitView() {
        mapState = .showingMap
        showing.toggleButton = true
    }
}

struct LocationVisitsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationVisitsView(mapState: .constant(.showingLocationVisits(.preview)), showing: .constant(.init()))
            .environment(\.managedObjectContext, CoreData.stack.context)
    }
}
