import Foundation
import ReactiveSwift
import ReactiveCocoa
import SafariServices
import Tentacle

final class AuthenticationCoordinator {
    
    fileprivate let navigationController: UINavigationController
    fileprivate let onboardingController: OnboardingController
    
    fileprivate let token = MutableProperty<Token?>(nil)
    fileprivate let repo = MutableProperty<Repository?>(nil)

    fileprivate var selectRepositoryCoordinator: SelectRepositoryCoordinator?
    
    init(navigationController: UINavigationController, onboardingController: OnboardingController) {
        self.navigationController = navigationController
        self.onboardingController = onboardingController
    }
    
    func start() {
        let auth = StoryboardScene.Main.instantiateAuthenticateWithGithub()
        auth.delegate = self
        navigationController.viewControllers = [auth]
    }
}

extension AuthenticationCoordinator: AuthenticationViewControllerDelegate {
    func didPressAuthenticate() {
        self.onboardingController.onboard().startWithResult { [weak self] result in
            switch result {
            case let .success(.openAuthorizeURL(url)):
                let safari = SFSafariViewController(url: url)
                self?.navigationController.present(safari, animated: true, completion: nil)
            case let .success(.token(token)):
                self?.navigationController.dismiss(animated: true, completion: nil)
                self?.token.swap(token)
                
                let controller = RepositoryController(client: Client(.dotCom, token: token.value))
                let coordinator = SelectRepositoryCoordinator(repositoryController: controller)
                coordinator.start()
                self?.navigationController.pushViewController(coordinator.controller, animated: true)
                self?.selectRepositoryCoordinator = coordinator
            case let .failure(error):
                self?.navigationController.dismiss(animated: true, completion: nil)
                print("Error = \(error)")
            }
        }
    }
}
