// Kevin Li - 10:46 AM - 2/28/20

import SwiftUI

// TODO: Monitor onForeground and call login on the userStore
struct LoginView: View {
    @EnvironmentObject var userStore: UserStore
    @State private var isLoading = false
    @State private var isLoggingIn = false

    var body: some View {
        ZStack {
            VStack {
                profileView
                iCloudLoginView
                Spacer()
            }

            if isLoading {
                loadingView
            }

            if isLoggingIn {
                LoggingInView()
            }

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
    private var profileView: some View {
        LottieView(fileName: "profile", repeatAnimation: !userStore.isLoggedIn)
            .frame(width: 250, height: 250)
    }

    private var loggingInView: some View {
        LottieView(fileName: "walking", repeatAnimation: !userStore.isLoggedIn)
            .frame(width: 100, height: 100)
    }

    private var iCloudLoginView: some View {
        HStack {
            Spacer()
            Image(systemName: "person.icloud.fill")
                .imageScale(.large)
                .foregroundColor(Color(.white))
                .padding(.leading)
            Text("Sign in With iCloud")
                .font(.headline)
                .padding(.leading)
            Spacer()
        }
        .frame(width: 343, height: 68)
        .background(BlurView(style: .systemMaterial))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color(.kingFisherDaisy).opacity(0.2), radius: 20, x: 0, y: 20)
        .onTapGesture(perform: logInToICloud)
    }

    private func logInToICloud() {
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.isLoggingIn = true
            self.isLoading = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+4) {
            self.userStore.logIn()
            self.isLoggingIn = false
        }
    }

    private var loadingView: some View {
        VStack {
            LottieView(fileName: "loading", repeatAnimation: true)
                .frame(width: 200, height: 200)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            .background(Color.black.opacity(show ? 0.5 : 0))
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
            .environmentObject(UserStore(loginService: MockLoginService()))
    }
}
