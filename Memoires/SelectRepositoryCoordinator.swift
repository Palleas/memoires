import Foundation
import ReactiveSwift
import Result
import Tentacle

final class SelectRepositoryCoordinator {
    
    let controller = StoryboardScene.Main.instantiateListViewController()
    
    private let repositories = MutableProperty<[Repository]>([])
    private let repositoryController: RepositoryController
    
    init(repositoryController: RepositoryController) {
        self.repositoryController = repositoryController
    }
    
    func start() {
        controller.title = L10n.SelectRepository.title
        
        repositoryController.all().startWithResult { result in
            print("Result = \(result)")
        }
    }
}



struct Action {
    let title: String
}

extension UIAlertController {
    static func create(title: String, message: String, actions: [Action], presenter: UIViewController) -> SignalProducer<Action, NoError> {
        return SignalProducer { [weak presenter] sink, disposable in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            actions.forEach { action in
                alert.addAction(UIAlertAction(title: action.title, style: .default) { _ in
                    sink.send(value: action)
                    sink.sendCompleted()
                })
            }
            
            presenter?.present(alert, animated: true)
        }
    }
}
