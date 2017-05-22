import Foundation
import ReactiveSwift
import ReactiveCocoa
import SafariServices

final class AuthenticationCoordinator {
    
    fileprivate let navigationController: UINavigationController
    fileprivate let onboardingController: OnboardingController
    
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
                print("token = \(token)")
            case let .failure(error):
                print("Error = \(error)")
            }
        }
    }
}
