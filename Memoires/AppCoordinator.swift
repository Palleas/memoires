import Foundation
import ReactiveSwift

final class AppCoordinator {
    
    private let rootController: RootViewController
    private let authenticationService: AuthenticationService
    private let onboardingController: OnboardingController
    
    private var authenticationCoordinator: AuthenticationCoordinator?
    
    init(rootController: RootViewController, authenticationService: AuthenticationService, onboardingController: OnboardingController) {
        self.rootController = rootController
        self.authenticationService = authenticationService
        self.onboardingController = onboardingController
    }
    
    func start() {
        // Setup appearance
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.mmrBlack]
        UINavigationBar.appearance().barTintColor = .mmrSunflowerYellow
        UINavigationBar.appearance().tintColor = .mmrBlack
        
        // Listen for state
        authenticationService
            .currentState
            .producer
            .map(createController)
            .observe(on: UIScheduler())
            .startWithValues { [weak self] controller in
                self?.rootController.transition(to: controller)
            }
    }
    
    func createController(for state: AuthenticationService.State) -> UIViewController {
        if case .anonymous = state {
            let nav = UINavigationController()
            authenticationCoordinator = AuthenticationCoordinator(navigationController: nav, onboardingController: onboardingController)
            authenticationCoordinator?.start()
            
            return nav
        }
        
        return StoryboardScene.Main.instantiateListViewController()
    }

}
