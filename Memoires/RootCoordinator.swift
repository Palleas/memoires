import Foundation

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

    override init() {
        self.onboarding = OnboardingController<StringTokenFactory>(credentials: credentials, redirectURI: "memoires://", tokenFactory: StringTokenFactory())

        super.init()
        
        let auth = AuthenticationCoordinator(onboarding: onboarding)
        controller.transition(to: auth.navigationController)
        children.append(auth)
    }
}
