import Foundation
import ReactiveSwift
import Result

final class AuthenticationService {
    
    enum State {
        case authenticated(Token)
        case anonymous
    }
    
    let currentState = MutableProperty(State.anonymous)
    
}
