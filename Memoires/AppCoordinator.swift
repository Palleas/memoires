import Foundation

final class AppCoordinator {
    
    private let rootController: RootViewController
    private let authenticationService: AuthenticationService
    
    init(rootController: RootViewController, authenticationService: AuthenticationService) {
        self.rootController = rootController
        self.authenticationService = authenticationService
    }
    
    func start() {
        authenticationService
            .currentState
            .producer
            .map(createController)
            .startWithValues { [weak self] controller in
                self?.rootController.transition(to: controller)
            }
    }
    
    func createController(for state: AuthenticationService.State) -> UIViewController {
        if case .anonymous = state {
            return UINavigationController(rootViewController: StoryboardScene.Main.instantiateAuthenticateWithGithub())
        }
        
        return StoryboardScene.Main.instantiateListViewController()
    }

}
