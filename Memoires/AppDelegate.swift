import UIKit
import KeychainSwift

// Implicit dependencies for ReactiveCocoa
import MapKit
import CoreLocation

struct StringTokenFactory: StateTokenFactory {
    
    func generate() -> Token {
        return Token(value: UUID().uuidString)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?
    
    let authService = AuthenticationService(keychain: KeychainSwift())
    var onboardingController: OnboardingController = {
        let cred = OnboardingController.Credentials(
            clientId: keyOrProcessEnv("GITHUB_CLIENT_ID"),
            clientSecret: keyOrProcessEnv("GITHUB_CLIENT_SECRET")
        )
        
        return OnboardingController(credentials: cred, redirectURI: "memoires://auth", tokenFactory: StringTokenFactory())
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        BuddyBuildSDK.setup()

        let root = StoryboardScene.Main.instantiateRoot()
        
        let window = UIWindow()
        window.rootViewController = root
        window.makeKeyAndVisible()
        self.window = window
        
        coordinator = AppCoordinator(rootController: root, authenticationService: authService, onboardingController: onboardingController)
        coordinator?.start()

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        onboardingController.finalizeAuthentication(with: url)
        
        return true
    }
}
