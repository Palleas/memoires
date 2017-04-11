import Foundation
import ReactiveSwift
import ReactiveCocoa
import UIKit
import SafariServices

final class AuthenticationCoordinator: Coordinator {
    enum Status {
        case unknown
        case authenticated(Token, Repository)
        case cancelled
    }
    
    let navigationController = UINavigationController()
    
    let status = MutableProperty<Status>(.unknown)
    
    private let onboarding: OnboardingController<StringTokenFactory>
    
    init(onboarding: OnboardingController<StringTokenFactory>) {
        self.onboarding = onboarding
        
        super.init()
        
        let controller = StoryboardScene.Main.instantiateAuthenticateWithGithub()
        _ = controller.view // meh
        controller.authenticateButton.addTarget(self, action: #selector(didTapAuthenticate), for: .touchUpInside)
        navigationController.viewControllers = [controller]
    }
    
    @objc func didTapAuthenticate() {
        onboarding.onboard().startWithResult { [weak self] result in
            switch result {
            case let .success(.openAuthorizeURL(url)):
                let browser = SFSafariViewController(url: url)
                self?.navigationController.present(browser, animated: true, completion: nil)
            case let .success(.fetchedToken(token)):
                self?.navigationController.dismiss(animated: true, completion: nil)
                print("Fetched token \(token)")
            case let .failure(error):
                self?.navigationController.dismiss(animated: true, completion: nil)
                print("Got error = \(error)")
            }
        }
    }
    
}
