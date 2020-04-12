import Introspect
import SwiftUI

enum RouteOverlayState: Equatable {
    case normal
    case editingLocationName
    case editingTag
    case editingNotes

    var isNormal: Bool {
        self == .normal
    }

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
    @State private var overlayState: RouteOverlayState = .normal
    @State private var animatingExit = false

    @Binding var mapState: MapState
    @ObservedObject var appState: AppState
    let color: Color

    private var currentVisit: Visit {
        appState.route.currentVisit
    }

    var body: some View {
        ZStack {
            if appState.route.exists {
                // Offset of 15 to account for the center annotation size
                centerIndicator
                    .offset(y: 15)
                controlButtons
                routeInfoAndControlsView
            }
        }
        .fade(if: animatingExit)
        .animation(.easeInOut)
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
            Group {
                header
                    .blurBackground(withPadding: true)
                Spacer()
            }
            .scaleFade(if: !overlayState.isNormal)

            VStack {
                detailView
                    .scaleFade(if: !overlayState.isNormal && !overlayState.isEditingLocationName)
                visitOptionsView
                    .scaleFade(if: overlayState.isEditingLocationName)
            }
            .padding(.bottom)
            .blurBackground(withPadding: !overlayState.isEditingTag)
        }
        .offset(y: overlayState.isEditingTag || overlayState.isEditingNotes ? -100 : 0)
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
        CloseRouteButton(animatingExit: $animatingExit, action: closeRoute)
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
    }

    private var nextLocationButton: some View {
        BImage(perform: selectNextLocation, image: Image(systemName: "chevron.compact.right"), frame: CGSize(width: 15, height: 30))
    }

    private func selectNextLocation() {
        appState.route.selectNextLocation()
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
        let nameInput = Binding(
            get: { self.currentVisit.location.name },
            set: { self.currentVisit.setLocationName($0) })

        return LocationNameView(
            nameInput: nameInput,
            color: color,
            setEditingStateForLocationName: setEditingStateForLocationName)
            .id(currentVisit)
    }

    private func setEditingStateForLocationName(_ isEditing: Bool) {
        if isEditing {
            overlayState = .editingLocationName
        } else {
            overlayState = .normal
        }
    }

    private func setLocationName(name: String) {
        currentVisit.setLocationName(name)
    }

    private struct LocationNameView: View {
        @Binding var nameInput: String

        let color: Color
        let setEditingStateForLocationName: (Bool) -> Void

        var body: some View {
            locationNameTextField
                .padding(.vertical)
                .padding(.horizontal, 32)
        }

        private var locationNameTextField: some View {
            LocationNameTextField(
                nameInput: $nameInput,
                textColor: color,
                onEditingChanged: setEditingStateForLocationName)
        }

        struct LocationNameTextField: View {
            @Binding var nameInput: String

            let textColor: Color
            let onEditingChanged: (Bool) -> Void

            var body: some View {
                TextField("Location Name", text: $nameInput, onEditingChanged: onEditingChanged)
                    .foregroundColor(textColor)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
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
        VisitOptionsView(overlayState: $overlayState, tagProvider: appState.route.self, visit: appState.route.currentVisit)
    }
}

private extension View {
    func blurBackground(withPadding: Bool) -> some View {
        self
            .padding(.horizontal, withPadding ? 16 : 0)
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
