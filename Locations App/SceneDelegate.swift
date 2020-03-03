import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let userStore = UserStore(loginService: ICloudLoginService(), themeColorService: ICloudThemeColorService())
        let locationService = CoreLocationService()
        let context = CoreData.stack.context
        let contentView = RootView(userStore: userStore, locationService: locationService)
            .environment(\.managedObjectContext, context)
            .statusBar(hidden: true)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreData.stack.save()
    }
}
