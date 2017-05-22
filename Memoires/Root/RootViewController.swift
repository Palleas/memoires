import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class RootViewController: UIViewController {
    
    private var mainView: RootView {
        return view as! RootView
    }
    
    func transition(to controller: UIViewController) {
        controller.willMove(toParentViewController: self)
        addChildViewController(controller)
        mainView.transition(to: controller.view)
        controller.didMove(toParentViewController: self)
    }
    
}
