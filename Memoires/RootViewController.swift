import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer(interval: .seconds(1), on: QueueScheduler())
            .startWithValues { date in
                print("Tick! (\(date))")
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
