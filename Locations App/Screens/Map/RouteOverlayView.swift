import Introspect
import SwiftUI

enum RouteOverlayState: Equatable {
    case showingEditTag(Location)
    case showingEditNotes(Visit)
}

struct RouteOverlayView: View {
    @State private var isEditing: Bool = false

    @Binding var route: AppState.Route
    @Binding var showing: AppState.Showing
    let color: Color

    private var currentVisit: Visit {
        route.currentVisit
    }

    var body: some View {
        ZStack {
            // Offset of 15 to account for the center annotation size
            centerIndicator
                .offset(y: 15)
            routeInfoAndControlsView
            controlButtons
        }
    }
}

private extension RouteOverlayView {
    private var centerIndicator: some View {
        CenterIndicator(color: color)
    }

    struct CenterIndicator: View {
        @State var show = false

        let color: Color

        var body: some View {
            Image(systemName: "triangle.fill")
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(color)
                .scaleEffect(show ? 1 : 0.5)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                .onAppear(perform: makeVisible)
        }

        private func makeVisible() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.show = true
            }
        }
    }
}

private extension RouteOverlayView {
    private var routeInfoAndControlsView: some View {
        VStack {
            header
                .blurBackground()
            Spacer()
            VStack {
                detailView
                visitOptionsView
            }
            .padding(.bottom)
            .blurBackground()
            .keyboardResponsive()
        }
    }
}

private extension RouteOverlayView {
    private var header: some View {
        HStack {
            routeInformationView
            Spacer()
            closeRouteButton
        }
        .padding()
    }

    private var routeInformationView: some View {
        VStack(alignment: .leading) {
            Text(route.date.fullMonthWithDayAndYear)
                .font(.title)
                .foregroundColor(color)
            HStack(alignment: .bottom, spacing: 2) {
                Text("\(route.currentIndex+1)")
                    .font(.title)
                    .bold()
                    .foregroundColor(color)
                Text("/ \(route.length)")
                    .font(.subheadline)
                    .foregroundColor(color)
                    .saturation(0.5)
                    .padding(.bottom, 4)
            }
        }
    }

    private var closeRouteButton: some View {
        CloseRouteButton(action: closeRoute)
    }

    private func closeRoute() {
        route.reset()
        showing.toggleButton = true
    }
}

private extension RouteOverlayView {
    private var controlButtons: some View {
        HStack {
            previousLocationButton
                .fade(if: route.isAtStart)
            Spacer()
            nextLocationButton
                .fade(if: route.isAtEnd)
        }
        .fade(if: isEditing)
        .foregroundColor(color)
        .padding(32)
    }

    private var previousLocationButton: some View {
        BImage(perform: selectPreviousLocation, image: Image(systemName: "chevron.compact.left"), frame: CGSize(width: 15, height: 30))
    }

    private func selectPreviousLocation() {
        route.selectPreviousLocation()
    }

    private var nextLocationButton: some View {
        BImage(perform: selectNextLocation, image: Image(systemName: "chevron.compact.right"), frame: CGSize(width: 15, height: 30))
    }

    private func selectNextLocation() {
        route.selectNextLocation()
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
        LocationNameView(name: currentVisit.location.name, color: color, setLocationName: setLocationName, isEditing: $isEditing)
            .id(currentVisit.location.name)
    }

    private func setLocationName(name: String) {
        currentVisit.setLocationName(name)
    }

    private struct LocationNameView: View {
        @State private var nameInput: String

        let setLocationName: (String) -> Void
        let color: Color
        @Binding var isEditing: Bool

        init(name: String, color: Color, setLocationName: @escaping (String) -> Void, isEditing: Binding<Bool>) {
            self._nameInput = State(initialValue: name)
            self.setLocationName = setLocationName
            self.color = color
            self._isEditing = isEditing
        }

        var body: some View {
            locationNameTextField
                .padding(.vertical)
                .padding(.horizontal, 32)
        }

        private var locationNameTextField: some View {
            LocationNameTextField(
                nameInput: $nameInput,
                isEditing: $isEditing,
                textColor: color,
                onCommit: _setLocationName)
        }

        struct LocationNameTextField: View {
            @Binding var nameInput: String
            @Binding var isEditing: Bool

            let textColor: Color
            let onCommit: () -> Void

            var body: some View {
                TextField("Location Name", text: $nameInput, onEditingChanged: onEditingChanged, onCommit: onCommit)
                    .foregroundColor(textColor)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            private func onEditingChanged(isEditing: Bool) {
                self.isEditing = isEditing
            }
        }

        private func _setLocationName() {
            setLocationName(nameInput)
        }
    }

    private var visitDurationText: some View {
        Text(currentVisit.duration)
            .foregroundColor(color)
            .animation(nil)
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
                .foregroundColor(visit.tagColor.color)
        }

        private var editNotesButton: some View {
            BImage(perform: {}, image: Image(systemName: "text.bubble.fill"))
        }

        private var favoriteButton: some View {
            FavoriteButton(visit: visit)
        }
    }
}

private extension View {
    func blurBackground() -> some View {
        self
            .padding(.horizontal)
            .background(
                BlurView(style: .systemUltraThinMaterialDark)
                    .cornerRadius(20)
                    .blur(radius: 20)
                    .edgesIgnoringSafeArea(.top))
    }
}

struct RouteOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        RouteOverlayView(route: .constant(.init(visits: Visit.previewVisits)), showing: .constant(.init()), color: .pink)
            .background(Color.gray.extendToScreenEdges())
    }
}
