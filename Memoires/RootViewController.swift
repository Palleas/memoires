import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class RootViewController: UIViewController {
    
    private var mainView: RootView {
        return view as! RootView
    }
    
    private var viewModel = RootViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vcProducer = viewModel.state.map(self.controller).producer
        vcProducer.observe(on: UIScheduler()).startWithValues { [weak self] controller in
            controller.willMove(toParentViewController: self)
            self?.addChildViewController(controller)
            self?.mainView.transition(to: controller.view)
            controller.didMove(toParentViewController: self)
        }
    }
    
    func controller(for state: RootViewModel.State) -> UIViewController {
        let items = ["BB", "Memoires", "Project"].map(Repository.init)
        
        let l = StoryboardScene.Main.instantiateCommonList()
        l.items = items
        
        return l
//        if case .unAuthenticated = state {
//            return UINavigationController(rootViewController: StoryboardScene.Main.instantiateAuthenticateWithGithub())
//        }
//        
//        return StoryboardScene.Main.instantiateListViewController()
    }

}
