import Introspect
import SwiftUI

enum RouteOverlayState: Equatable {
    case none
    case editingLocationName
    case editingTag
    case editingNotes

    var isEditingLocationName: Bool {
        self == .editingLocationName
    }

    var isEditingTag: Bool {
        self == .editingTag
    }

    var isEditingNotes: Bool {
        self == .editingNotes
    }
}

struct RouteOverlayView: View {
    @State private var overlayState: RouteOverlayState = .none

    @Binding var mapState: MapState
    @ObservedObject var appState: AppState
    let color: Color

    private var currentVisit: Visit {
        appState.route.currentVisit
    }

    var blurBackground: Bool {
        overlayState != .none
    }

    var body: some View {
        ZStack {
            // Offset of 15 to account for the center annotation size
            Group {
                centerIndicator
                    .offset(y: 15)
                routeInfoAndControlsView
                controlButtons
            }

            editTagView
                .modal(isPresented: overlayState.isEditingTag)
        }
    }
}

private extension RouteOverlayView {
    private var centerIndicator: some View {
        CenterIndicatorView(locationControl: $appState.locationControl, route: $appState.route, color: color)
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
            Text(appState.route.date.fullMonthWithDayAndYear)
                .font(.title)
                .foregroundColor(color)
            HStack(alignment: .bottom, spacing: 2) {
                Text("\(appState.route.currentIndex+1)")
                    .font(.title)
                    .bold()
                    .foregroundColor(color)
                Text("/ \(appState.route.length)")
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
        appState.route.reset()
        appState.showing.toggleButton = true
    }
}

private extension RouteOverlayView {
    private var controlButtons: some View {
        HStack {
            previousLocationButton
                .fade(if: appState.route.isAtStart)
            Spacer()
            nextLocationButton
                .fade(if: appState.route.isAtEnd)
        }
        .fade(if: overlayState.isEditingLocationName)
        .foregroundColor(color)
        .padding(32)
    }

    private var previousLocationButton: some View {
        BImage(perform: selectPreviousLocation, image: Image(systemName: "chevron.compact.left"), frame: CGSize(width: 15, height: 30))
    }

    private func selectPreviousLocation() {
        appState.route.selectPreviousLocation()
        setLocationCenterCoordinate()
    }

    private var nextLocationButton: some View {
        BImage(perform: selectNextLocation, image: Image(systemName: "chevron.compact.right"), frame: CGSize(width: 15, height: 30))
    }

    private func selectNextLocation() {
        appState.route.selectNextLocation()
        setLocationCenterCoordinate()
    }

    private func setLocationCenterCoordinate() {
        appState.locationControl.centerCoordinate = appState.route.currentVisit.location.coordinate
        appState.locationControl.shouldCenterForRoute = true
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
        LocationNameView(
            name: currentVisit.location.name,
            color: color,
            setLocationName: setLocationName,
            setEditingStateForLocationName: setEditingStateForLocationName)
            .id(currentVisit)
    }

    private func setEditingStateForLocationName(_ isEditing: Bool) {
        if isEditing {
            overlayState = .editingLocationName
        } else {
            overlayState = .none
        }
    }

    private func setLocationName(name: String) {
        currentVisit.setLocationName(name)
    }

    private struct LocationNameView: View {
        @State private var nameInput: String

        let setLocationName: (String) -> Void
        let color: Color
        let setEditingStateForLocationName: (Bool) -> Void

        init(name: String, color: Color, setLocationName: @escaping (String) -> Void, setEditingStateForLocationName: @escaping (Bool) -> Void) {
            self._nameInput = State(initialValue: name)
            self.setLocationName = setLocationName
            self.color = color
            self.setEditingStateForLocationName = setEditingStateForLocationName
        }

        var body: some View {
            locationNameTextField
                .padding(.vertical)
                .padding(.horizontal, 32)
        }

        private var locationNameTextField: some View {
            LocationNameTextField(
                nameInput: $nameInput,
                textColor: color,
                onEditingChanged: setEditingStateForLocationName,
                onCommit: _setLocationName)
        }

        struct LocationNameTextField: View {
            @Binding var nameInput: String

            let textColor: Color
            let onEditingChanged: (Bool) -> Void
            let onCommit: () -> Void

            var body: some View {
                TextField("Location Name", text: $nameInput, onEditingChanged: onEditingChanged, onCommit: onCommit)
                    .foregroundColor(textColor)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
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
        BImage(perform: setStateToEditingTag, image: Image(systemName: "tag.fill"))
            .foregroundColor(currentVisit.tagColor.color)
    }

    private func setStateToEditingTag() {
        overlayState = .editingTag
    }

    private var editNotesButton: some View {
        BImage(perform: setStateToEditingNotes, image: Image(systemName: "text.bubble.fill"))
    }

    private func setStateToEditingNotes() {
        overlayState = .editingNotes
    }

    private var favoriteButton: some View {
        FavoriteButton(visit: currentVisit)
            .id(currentVisit.isFavorite)
    }
}

private extension RouteOverlayView {
    private var editTagView: some View {
        EditTagView(tagProvider: appState.route.self, onReset: {})
    }
}

private extension View {
    func modal(isPresented: Bool) -> some View {
        self
            .frame(width: screen.width, height: screen.height * 0.8)
            .offset(y: isPresented ? 0 : screen.height)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.8).extendToScreenEdges())
            .fade(if: !isPresented)
            .animation(.spring())
    }

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
        RouteOverlayView(mapState: .constant(.showingMap), appState: .init(), color: .red)
            .background(Color.gray.extendToScreenEdges())
    }
}
