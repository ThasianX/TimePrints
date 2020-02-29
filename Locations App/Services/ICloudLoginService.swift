// Kevin Li - 11:22 PM - 2/28/20

import CloudKit
import Foundation

class ICloudLoginService: LoginService, ObservableObject {
    let cloudContainer = CKContainer.default()

    var isUserLoggedIn: Bool {
        ICloudKVS.Account.bool(forKey: .isUserLoggedIn)
    }

    func logIn() {

    }
}

protocol LoginService {
    var isUserLoggedIn: Bool { get }
    func logIn()
}
