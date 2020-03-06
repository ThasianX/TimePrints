import SwiftUI
import Mapbox

let screen = UIScreen.main.bounds
let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

struct RootView: View {
    @ObservedObject var userStore: UserStore
    @FetchRequest(entity: Location.entity(), sortDescriptors: []) var locations: FetchedResults<Location>

    @State private var showingToggleButton: Bool = true
    @State private var stayAtLocation = false
    @State private var showingHomeView = false

    @State private var activeVisitLocation: Location? = nil

    var body: some View {
        ZStack(alignment: .bottom) {
            viewForLoginState

            transientSplashView
        }
    }
}

private extension RootView {
    private var viewForLoginState: some View {
        Group {
            if !userStore.isLoggedIn {
                loginView
            } else if !userStore.isInitialThemeSetup {
                themePickerViewWithButton
            } else {
                appView
                    .environment(\.appTheme, userStore.themeColor)
            }
        }
    }

    private var transientSplashView: TransientSplashView {
        TransientSplashView()
    }
}

private extension RootView {
    private var loginView: LoginView {
        LoginView(userStore: userStore)
    }
}

private extension RootView {
    private var themePickerViewWithButton: some View {
        ZStack(alignment: .topTrailing) {
            themePickerView
            transitionToAppButton
                .padding(.top)
                .padding(.trailing, 35)
        }
    }

    private var themePickerView: ThemePickerView {
        ThemePickerView(startingThemeColor: userStore.themeColor, onSelected: userStore.setThemeColor)
    }

    private var transitionToAppButton: DimensionalButton {
        DimensionalButton(image: Image(systemName: "arrow.right"), action: userStore.finalizeInitialThemeSetup, circleColor: UIColor.kingFisherDaisy.color)
    }
}

private extension RootView {
    private var appView: some View {
        Group {
            visitsHomeView
                .fade(if: !showingHomeView)

            appMapView
                .fade(if: showingHomeView)
                .onAppear(perform: userStore.performLocationAndDatabaseOperations)

            toggleViewButton
                .fade(if: !showingToggleButton)
        }
    }

    private var visitsHomeView: some View {
        VisitsHomeView(showingHomeView: $showingHomeView, activeVisitLocation: $activeVisitLocation)
    }

    private var appMapView: some View {
        AppMapView(showingToggleButton: $showingToggleButton, stayAtLocation: $stayAtLocation, activeVisitLocation: $activeVisitLocation)
    }

    private var toggleViewButton: some View {
        ZStack {
            toggleBackgroundColor
            BImage(perform: toggleVisitsPreviewAndStayAtLocation, image: toggleImage)
                .foregroundColor(toggleForegroundColor)
        }
        .frame(width: 50, height: 50)
        .clipShape(Circle())
    }

    private var toggleBackgroundColor: Color {
        showingHomeView ? .green : .white
    }

    private func toggleVisitsPreviewAndStayAtLocation() {
        activeVisitLocation = nil
        showingHomeView.toggle()
        stayAtLocation = true
    }

    private var toggleImage: Image {
        showingHomeView ? Image(systemName: "map.fill") : Image(systemName: "list.dash")
    }

    private var toggleForegroundColor: Color {
        showingHomeView ? .white : .black
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(userStore: .mockSuccessLogin)
    }
}

