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

    override init() {
        super.init()
        
        let auth = AuthenticationCoordinator()
        auth.status.producer.startWithValues { status in
            switch status {
            case .cancelled:
                self.controller.transition(to: UIViewController())
            default: print("boo")
            }
        }
        controller.transition(to: auth.navigationController)
        children.append(auth)
    }
}
