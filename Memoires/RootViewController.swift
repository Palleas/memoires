import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class RootViewController: UIViewController {
    
    private var mainView: RootView {
        return view as! RootView
    }
        
    func transition(to viewController: UIViewController) {
        viewController.willMove(toParentViewController: self)
        addChildViewController(viewController)
        mainView.transition(to: viewController.view)
        viewController.didMove(toParentViewController: self)
        
    }

}
