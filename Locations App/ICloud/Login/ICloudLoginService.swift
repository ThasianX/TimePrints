// Kevin Li - 11:22 PM - 2/28/20

import Foundation

final class ICloudLoginService: LoginService {
    var isUserLoggedIn: Bool {
        ICloudKVS.Account.bool(forKey: .isUserLoggedIn)
    }

    func logIn(completion: @escaping (Bool) -> ()) {
        if isICloudAvailable {
            logInUser()
        }
        completion(isICloudAvailable)
    }

    var isICloudAvailable: Bool {
        // Opaque token that represents the user's iCloud identity; nil if not logged into iCloud
        FileManager.default.ubiquityIdentityToken != nil
    }

    private func logInUser() {
        ICloudKVS.Account.set(true, for: .isUserLoggedIn)
    }

    func logOut() {
        ICloudKVS.Account.set(false, for: .isUserLoggedIn)
    }
}
