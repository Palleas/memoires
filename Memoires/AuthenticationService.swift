import Foundation
import ReactiveSwift
import Result
import KeychainSwift

final class AuthenticationService {

    enum State {
        case authenticated(Token)
        case anonymous
    }
    
    let currentState = MutableProperty(State.anonymous)
    
    private let keychain: KeychainSwift
    
    init(keychain: KeychainSwift) {
        self.keychain = keychain
        
        if let token = keychain.get("token").flatMap(Token.init) {
            currentState.swap(.authenticated(token))
        }
    }
    
    func store(_ token: Token) {
        keychain.set(token.value, forKey: "token")
        currentState.swap(.authenticated(token))
    }
    
}
