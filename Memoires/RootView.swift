import UIKit

final class RootView: UIView {
    private var containedView: UIView?
    
    func transition(to view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leftAnchor.constraint(equalTo: leftAnchor),
            view.rightAnchor.constraint(equalTo: rightAnchor),
            view.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        
        guard let containedView = containedView else {
            self.containedView = view
            return
        }
        
        UIView.transition(from: containedView, to: view, duration: 0.5, options: .transitionCrossDissolve) { _ in
            self.containedView = view
        }
    }

}
