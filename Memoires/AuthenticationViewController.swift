import UIKit

protocol AuthenticationViewControllerDelegate: class {
    func didPressAuthenticate()
}

final class AuthenticationViewController: UIViewController {
    weak var delegate: AuthenticationViewControllerDelegate?
    
    @IBAction func authenticate(_ sender: Any) {
        delegate?.didPressAuthenticate()
    }
}
