import SwiftUI
import Mapbox

let screen = UIScreen.main.bounds
let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

struct RootView: View {
    @ObservedObject var userStore: UserStore

    @State private var showingToggleButton: Bool = true
    @State private var stayAtLocation: Bool = false
    @State private var showingHomeView: Bool = false

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
        AppView(onAppear: userStore.performLocationAndDatabaseOperations)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(userStore: .mockSuccessLogin)
    }
}

