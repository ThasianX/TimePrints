// Kevin Li - 10:46 AM - 2/28/20

import SwiftUI

// TODO: Monitor onForeground and call login on the userStore
struct LoginView: View {
    @EnvironmentObject var userStore: UserStore
    @State private var isLoading = false
    @State private var isLoggingIn = false

    var body: some View {
        ZStack {
            mainView

            loadingViewIfLoading

            loggingInViewIfLoggingIn

            if userStore.alert != nil {
                VStack {
                    Text(userStore.alert!.message)
                    LottieView(fileName: userStore.alert!.lottieFile)
                }
            }
        }
    }

}

private extension LoginView {
    private var mainView: some View {
        VStack {
            profileLottieView
            iCloudLoginButton
            Spacer()
        }
    }

    private var profileLottieView: some View {
        LottieView(fileName: "profile", repeatAnimation: !userStore.isLoggedIn)
            .frame(width: 250, height: 250)
    }

    private var iCloudLoginButton: some View {
        HStack {
            iCloudImage
            iCloudSignInText
        }
        .frame(width: 343, height: 68)
        .background(BlurView(style: .systemMaterial))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color(.kingFisherDaisy).opacity(0.5), radius: 20)
        .onTapGesture(perform: logInToICloud)
    }

    private var iCloudImage: some View {
        Image(systemName: "icloud.fill")
            .imageScale(.large)
            .foregroundColor(Color(.white))
    }

    private var iCloudSignInText: some View {
        Text("Sign in With iCloud")
            .font(.headline)
    }

    private var loadingAnimationTime: Double { 2 }
    private var loggingInAnimationTime: Double { 2 }

    private func logInToICloud() {
        showLoadingView()

        DispatchQueue.main.asyncAfter(deadline: .now() + loadingAnimationTime) {
            self.showLoggingInView()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + loadingAnimationTime + loggingInAnimationTime) {
            self.logIn()
        }
    }

    private func showLoadingView() {
        isLoading = true
    }

    private func showLoggingInView() {
        isLoggingIn = true
        isLoading = false
    }

    private func logIn() {
        self.userStore.logIn()
        isLoggingIn = false
    }
}

private extension LoginView {
    private var loadingViewIfLoading: some View {
        Group {
            if isLoading {
                loadingView
            }
        }
    }

    private var loadingView: some View {
        VStack {
            LottieView(fileName: "loading", repeatAnimation: true)
                .frame(width: 200, height: 200)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var loggingInViewIfLoggingIn: some View {
        Group {
            if isLoggingIn {
                loggingInView
            }
        }
    }

    private var loggingInView: some View {
        LoggingInView()
    }

    private struct LoggingInView: View {
        @State var show = false

        var body: some View {
            VStack {
                LottieView(fileName: "walking", repeatAnimation: true)
                    .frame(width: 300, height: 200)
                    .opacity(show ? 1 : 0)
                    .animation(Animation.linear(duration: 1).delay(0.4))
                    .scaleEffect(1.3)
            }
            .frame(width: 300, height: 275)
            .background(BlurView(style: .systemMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 30, x: 0, y: 30)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaleEffect(show ? 1 : 0.5)
            .background(Color.black.opacity(show ? 0.7 : 0))
            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
            .onAppear {
                self.show = true
            }
        }
    }

    private struct AlertView: View {
        @State var show = false

        var body: some View {
            VStack {
                LottieView(fileName: "walking", repeatAnimation: true)
                    .frame(width: 300, height: 200)
                    .opacity(show ? 1 : 0)
                    .animation(Animation.linear(duration: 1).delay(0.4))
                    .scaleEffect(1.3)
            }
            .frame(width: 300, height: 275)
            .background(BlurView(style: .systemMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 30, x: 0, y: 30)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaleEffect(show ? 1 : 0.5)
            .background(Color.black.opacity(show ? 0.7 : 0))
            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
            .onAppear {
                self.show = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserStore(loginService: MockSuccessLoginService()))
    }
}
