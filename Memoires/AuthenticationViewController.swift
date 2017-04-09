import UIKit
import ReactiveSwift
import ReactiveCocoa

final class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var authenticateButton: UIButton!
    
    let url = MutableProperty<URL?>(nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
