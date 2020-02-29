// Kevin Li - 4:15 PM - 2/29/20

import SwiftUI

final class UserStore: ObservableObject {
    private let loginService: LoginService

    @Published var isLoggedIn: Bool
    @Published var alert: Alert? = nil

    init(loginService: LoginService) {
        self.loginService = loginService
        isLoggedIn = loginService.isUserLoggedIn
    }

    func logIn() {
        loginService.logIn() { loggedIn in
            loggedIn ? self.userIsLoggedIn() : self.userIsNotLoggedIn()
        }
    }

    private func userIsLoggedIn() {
        // TODO: After logging in, let user choose a theme color for the app, then initialize the CoreData stack and prompt for location permissions
        setLoggedInAlert()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoggedIn = true
        }
    }

    private func userIsNotLoggedIn() {
        setNotLoggedInAlert()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.openSettings()
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

    func logOut() {
        loginService.logOut()
    }
}
