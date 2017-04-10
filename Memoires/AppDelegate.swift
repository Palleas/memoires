import UIKit

// Implicit dependencies for ReactiveCocoa
import MapKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var root = RootCoordinator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        BuddyBuildSDK.setup()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = root.controller
        window.makeKeyAndVisible()
        self.window = window

        setupAppearance()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        return root.handle(url: url)
        return true
    }
    
    func setupAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.mmrBlack
        ]
        UINavigationBar.appearance().barTintColor = .mmrSunflowerYellow
        UINavigationBar.appearance().tintColor = .mmrBlack
    }
}
