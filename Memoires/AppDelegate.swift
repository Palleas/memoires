import UIKit

// Implicit dependencies for ReactiveCocoa
import MapKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        BuddyBuildSDK.setup()
        

        let root = StoryboardScene.Main.instantiateRoot()
        
        let window = UIWindow()
        window.rootViewController = root
        window.makeKeyAndVisible()
        self.window = window

        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.mmrBlack
        ]
        UINavigationBar.appearance().barTintColor = .mmrSunflowerYellow
        UINavigationBar.appearance().tintColor = .mmrBlack

        
        return true
    }

}
