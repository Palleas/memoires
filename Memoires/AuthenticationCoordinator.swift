import Foundation
import ReactiveSwift
import UIKit

protocol Token {}

final class AuthenticationCoordinator: Coordinator {
    enum Status {
        case unknown
        case authenticated(Token, Repository)
        case cancelled
    }
    
    let navigationController = UINavigationController()
    
    let status = MutableProperty<Status>(.unknown)
    
    override init() {
        super.init()
        
        let controller = StoryboardScene.Main.instantiateAuthenticateWithGithub()
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationController.viewControllers = [controller]
    }
    
    @objc func didTapCancel() {
        status.swap(.cancelled)
    }
}
