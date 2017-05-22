import Foundation
import ReactiveSwift

struct RootViewModel {
    
    enum State {
        case unAuthenticated
        case authenticated
    }
    
    let state = MutableProperty<State>(.unAuthenticated)
    
}
