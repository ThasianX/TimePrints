// Kevin Li - 11:22 PM - 2/28/20

import CloudKit
import Foundation
import UIKit

protocol LoginService {
    var isUserLoggedIn: Bool { get }
    func logIn()
}

final class ICloudLoginService: LoginService, ObservableObject {
    private let fileManager = FileManager.default
    private let container = CKContainer.default()

    var isUserLoggedIn: Bool {
        // When this is true, display a checkmark in the loginview. When not true, just display the lottie profile animation
        ICloudKVS.Account.bool(forKey: .isUserLoggedIn)
    }

    var loginFailed = false

    func logIn() {
        // Opaque token that represents the user's iCloud identity. If the user isn't logged into iCloud, this value is nil
        let currentToken = fileManager.ubiquityIdentityToken
        // Start the logging in animation for 1-2 seconds in the view
        if currentToken != nil {
            // Log the user in and prompt for permissions. Initialize CoreData stack - either user is new or existing
            logInUser()
        } else {
            // Show a sign into icloud animation and then send the user to settings. Monitor enterforeground and call login
            notifyUserLoginFailed()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
                self.openSettings()
            }
        }

    }

    private func logInUser() {
        ICloudKVS.Account.set(true, for: .isUserLoggedIn)
        objectWillChange.send()
    }

    private func notifyUserLoginFailed() {
        loginFailed = true
        objectWillChange.send()
    }

    private func openSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
}
