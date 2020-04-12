// Kevin Li - 4:08 PM - 2/29/20

import Foundation

protocol LottieAlert {
    var message: String { get }
    var lottieFile: String { get }
}

struct LoggedInAlert: LottieAlert {
    var message: String = "Successfully logged in with iCloud."
    var lottieFile: String = "check3"
}

struct NotLoggedInAlert: LottieAlert {
    var message: String = "Failed to log in. You must sign into iCloud."
    var lottieFile: String = "error"
}
