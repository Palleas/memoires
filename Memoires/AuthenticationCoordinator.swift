import Foundation
import ReactiveSwift
import ReactiveCocoa
import UIKit
import SafariServices

protocol Token {}

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
            case let .failure(error):
                print("Got error = \(error)")
            }
        }
    }
    
}