// Kevin Li - 10:46 AM - 2/28/20

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var loginService: ICloudLoginService

    var body: some View {
        ZStack {
            VStack {
                profileView
                iCloudLoginView
                wavelengthView
                Spacer()
            }
        }
    }

}

private extension LoginView {
    private var profileView: some View {
        LottieView(fileName: "profile", repeatAnimation: !loginService.isUserLoggedIn)
            .frame(width: 250, height: 250)
    }

    private var wavelengthView: some View {
        LottieView(fileName: "wavelength", repeatAnimation: !loginService.isUserLoggedIn)
            .frame(height: 150)
    }

    private var loadingView: some View {
        LottieView(fileName: "walking", repeatAnimation: !loginService.isUserLoggedIn)
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
        loginService.logIn()
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(ICloudLoginService())
    }
}
