import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class RootViewController: UIViewController {
    
    private var mainView: RootView {
        return view as! RootView
    }
    
    private var viewModel = RootViewModel()

    private let onboarding = OnboardingController(
        credentials: Credentials(
            clientId: BuddyBuildSDK.value(forDeviceKey: "GITHUB_CLIENT_ID") ?? ProcessInfo.processInfo.environment["GITHUB_CLIENT_ID"]!,
            clientSecret: BuddyBuildSDK.value(forDeviceKey: "GITHUB_CLIENT_SECRET") ?? ProcessInfo.processInfo.environment["GITHUB_CLIENT_SECRET"]!
        ),
        redirectURI: "memoires://auth",
        tokenFactory: StringTokenFactory()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vcProducer = viewModel.state.map(self.controller).producer
        vcProducer.observe(on: UIScheduler()).startWithValues { [weak self] controller in
            self?.transition(to: controller)
        }
    }
    
    func transition(to viewController: UIViewController) {
        viewController.willMove(toParentViewController: self)
        addChildViewController(viewController)
        mainView.transition(to: viewController.view)
        viewController.didMove(toParentViewController: self)
        
    }
    
    func controller(for state: RootViewModel.State) -> UIViewController {
        if case .unAuthenticated = state {
            let authenticate = StoryboardScene.Main.instantiateAuthenticateWithGithub()
            return UINavigationController(rootViewController: authenticate)
        }
        
        return StoryboardScene.Main.instantiateListViewController()
    }
    
    func handle(url: URL) -> Bool {
        onboarding.finalizeAuthentication(with: url)
        
        return true
    }

}
