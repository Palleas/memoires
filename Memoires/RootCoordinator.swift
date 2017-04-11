import Foundation
import MemoiresKit

class Coordinator {
    internal var children = [Coordinator]()
}

final class RootCoordinator: Coordinator {
    
    private(set) lazy var controller = StoryboardScene.Main.instantiateRoot()
    
    private let credentials = Credentials(
        clientId: keyOrProcessEnv("GITHUB_CLIENT_ID"),
        clientSecret: keyOrProcessEnv("GITHUB_CLIENT_SECRET")
    )
    
    private let onboarding: OnboardingController<StringTokenFactory>
    private let environment: Environment
    
    init(environment: Environment) {
        self.environment = environment
        
        self.onboarding = OnboardingController<StringTokenFactory>(credentials: credentials, redirectURI: "memoires://auth", tokenFactory: StringTokenFactory())

        super.init()
        
        let auth = AuthenticationCoordinator(onboarding: onboarding)
        controller.transition(to: auth.navigationController)
        children.append(auth)
    }
    
    func handle(url: URL) -> Bool {
        guard let scheme = url.scheme, scheme == "memoires" else { return false }
        
        onboarding.finalizeAuthentication(with: url)
        
        return true
    }
}
