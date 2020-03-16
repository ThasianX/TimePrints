import Introspect
import SwiftUI

enum RouteOverlayState: Equatable {
    case showingEditTag(Location)
    case showingEditNotes(Visit)
}

struct RouteOverlayView: View {
    @Binding var route: AppState.Route
    let color: Color

    private var currentVisit: Visit {
        route.currentVisit
    }

    var body: some View {
        VStack {
            header
            Spacer()
            detailView
            visitOptionsView
        }
    }
}

private extension RouteOverlayView {
    private var header: some View {
        HStack {
            closeRouteButton
            Spacer()
            routeInformationView
            Spacer()
            nextLocationButton
        }
        .padding()
    }

    private var closeRouteButton: some View {
        CloseRouteButton(route: $route)
    }

    private var routeInformationView: some View {
        VStack {
            Text(route.date.fullMonthWithDayAndYear)
            Text("\(route.currentIndex) / \(route.length)")
        }
    }

    private var nextLocationButton: some View {
        NextLocationButton(route: $route, color: color)
    }
}

private extension RouteOverlayView {
    private var detailView: some View {
        VStack {
            locationNameView
            visitDurationText
        }
    }

    private var locationNameView: some View {
        LocationNameView(name: currentVisit.location.name, color: color)
    }

    private func setLocationName(name: String) {
        currentVisit.setLocationName(name)
    }

    private struct LocationNameView: View {
        @State private var nameInput: String
        @State private var isEditingEnabled: Bool = false

        let setLocationName: (String) -> Void
        let color: Color

        init(name: String, color: Color) {
            self._nameInput = State(initialValue: name)
            self.setLocationName = { _ in}
            self.color = color
        }

        var body: some View {
            HStack {
                locationNameTextField
                editButton
            }
            .padding()
            .keyboardResponsive()
        }

        private var locationNameTextField: some View {
            LocationNameTextField(nameInput: $nameInput, isEnabled: isEditingEnabled, textColor: color, onCommit: _setLocationName)
        }

        struct LocationNameTextField: View {
            @Binding var nameInput: String

            let isEnabled: Bool
            let textColor: Color
            let onCommit: () -> Void

            var body: some View {
                TextField("Location Name", text: $nameInput, onCommit: onCommit)
                    .foregroundColor(textColor)
                    .disabled(!isEnabled)
                    .introspectTextField { textField in
                        _ = self.isEnabled ? textField.becomeFirstResponder() : textField.resignFirstResponder()
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }

        private func _setLocationName() {
            setLocationName(nameInput)
        }

        private var editButton: some View {
            BImage(perform: toggleEditing, image: Image(systemName: "pencil"))
                .foregroundColor(isEditingEnabled ? .red : .green)
        }

        private func toggleEditing() {
            isEditingEnabled.toggle()
        }
    }

    private var visitDurationText: some View {
        Text(currentVisit.duration)
    }
}

private extension RouteOverlayView {
    private var visitOptionsView: some View {
        VisitOptions(visit: currentVisit)
    }

    private struct VisitOptions: View {
        let visit: Visit

        var body: some View {
            HStack {
                editTagButton
                Spacer()
                editNotesButton
                Spacer()
                favoriteButton
            }
            .padding()
        }

        private var editTagButton: some View {
            BImage(perform: {}, image: Image(systemName: "tag.fill"))
        }

        private var editNotesButton: some View {
            BImage(perform: {}, image: Image(systemName: "text.bubble.fill"))
        }

        private var favoriteButton: some View {
            FavoriteButton(visit: visit)
        }
    }
}

struct RouteOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        RouteOverlayView(route: .constant(.init(visits: Visit.previewVisits)), color: .pink)
    }
}
