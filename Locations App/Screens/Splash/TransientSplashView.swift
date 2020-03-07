import SwiftUI

struct TransientSplashView: View {
    @State private var showSplash = true

    var body: some View {
        Group {
            if showSplash {
                splashScreen
            }
        }
    }

    private var splashScreen: SplashScreen {
        SplashScreen(show: $showSplash)
    }
}

struct TransientSplashView_Previews: PreviewProvider {
    static var previews: some View {
        TransientSplashView()
    }
}
