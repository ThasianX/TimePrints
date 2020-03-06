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
            viewForAppState
            transientSplashView
        }
    }
}

private extension RootView {
    private var viewForAppState: some View {
        Group {
            if !userStore.isLoggedIn {
                loginView
            } else if !userStore.isInitialThemeSetup {
                setupThemePickerView
            } else {
                appView
                    .environment(\.appTheme, userStore.themeColor)
            }
        }
    }

    private var loginView: LoginView {
        LoginView(userStore: userStore)
    }

    private var setupThemePickerView: some View {
        SetupThemePickerView(defaultThemeColor: userStore.themeColor, onSelected: userStore.setThemeColor, onFinalize: userStore.finalizeInitialThemeSetup)
    }

    private var appView: some View {
        AppView(onAppear: userStore.performLocationAndDatabaseOperations)
    }

    private var transientSplashView: TransientSplashView {
        TransientSplashView()
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(userStore: .mockSuccessLogin)
    }
}

