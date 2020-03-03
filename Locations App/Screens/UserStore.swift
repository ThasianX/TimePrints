// Kevin Li - 4:15 PM - 2/29/20

import SwiftUI

extension UserStore {
    static let mockSuccessLogin: UserStore = {
        UserStore(loginService: MockSuccessLoginService(), themeColorService: MockIsNotSetThemeColorService())
    }()

    static let mockFailedLogin: UserStore = {
        UserStore(loginService: MockFailureLoginService(), themeColorService: MockIsNotSetThemeColorService())
    }()
}

final class UserStore: ObservableObject {
    @Published var isLoggedIn: Bool
    @Published var alert: Alert? = nil

    @Published var isThemeColorSet: Bool

    private let loginService: LoginService
    private let themeColorService: ThemeColorService
    private let alertAnimationDuration: Double = 2.5

    init(loginService: LoginService, themeColorService: ThemeColorService) {
        isLoggedIn = loginService.isUserLoggedIn
        isThemeColorSet = themeColorService.isThemeColorSet
        self.loginService = loginService
        self.themeColorService = themeColorService
    }

    func logIn() {
        loginService.logIn() { loggedIn in
            loggedIn ? self.userIsLoggedIn() : self.userIsNotLoggedIn()
        }
    }

    func logOut() {
        loginService.logOut()
    }

    var themeColor: UIColor {
        UIColor(themeColorService.themeColor)
    }

    func setThemeColor(color: UIColor) {
        themeColorService.setThemeColor(hexString: color.hexString())
    }
}

extension UserStore {
    private func userIsLoggedIn() {
        setLoggedInAlert()
        setDefaultThemeColor()

        DispatchQueue.main.asyncAfter(deadline: .now() + alertAnimationDuration) {
            self.isLoggedIn = true
        }
    }

    private func setLoggedInAlert() {
        alert = LoggedInAlert()
    }

    private func setDefaultThemeColor() {
        setThemeColor(color: AppColors.themes.first!)
    }

    private func userIsNotLoggedIn() {
        setNotLoggedInAlert()

        DispatchQueue.main.asyncAfter(deadline: .now() + alertAnimationDuration) {
            self.openSettings()
            self.resetAlert()
        }
    }

    private func setNotLoggedInAlert() {
        alert = NotLoggedInAlert()
    }

    private func openSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }

    private func resetAlert() {
        alert = nil
    }
}
