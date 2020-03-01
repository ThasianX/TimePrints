// Kevin Li - 4:15 PM - 2/29/20

import SwiftUI

final class UserStore: ObservableObject {
    @Published var isLoggedIn: Bool
    @Published var alert: Alert? = nil

    private let loginService: LoginService
    private let alertAnimationDuration: Double = 2.5

    init(loginService: LoginService) {
        isLoggedIn = loginService.isUserLoggedIn
        self.loginService = loginService
    }

    func logIn() {
        loginService.logIn() { loggedIn in
            loggedIn ? self.userIsLoggedIn() : self.userIsNotLoggedIn()
        }
    }

    private func userIsLoggedIn() {
        // TODO: After logging in, let user choose a theme color for the app, then initialize the CoreData stack and prompt for location permissions
        setLoggedInAlert()

        DispatchQueue.main.asyncAfter(deadline: .now() + alertAnimationDuration) {
            self.isLoggedIn = true
        }
    }

    private func userIsNotLoggedIn() {
        setNotLoggedInAlert()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + alertAnimationDuration) {
            self.openSettings()
            self.resetAlert()
        }
    }

    private func openSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }

    private func setLoggedInAlert() {
        alert = LoggedInAlert()
    }

    private func setNotLoggedInAlert() {
        alert = NotLoggedInAlert()
    }

    private func resetAlert() {
        alert = nil
    }

    func logOut() {
        loginService.logOut()
    }
}
