// Kevin Li - 7:04 PM - 5/28/20

import SwiftUI

extension AnyTransition {

    static var scaleFade: AnyTransition {
        AnyTransition.scale.combined(with: .opacity)
    }

}
