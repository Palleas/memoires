import Foundation
import ReactiveSwift

struct Token {
    let value: String
}

extension Token: AutoEquatable {}

protocol StateTokenFactory {

    func generate() -> Token
    
}

final class OnboardingController {

    struct Credentials {
        let clientId: String
        let clientSecret: String
    }
    
    enum OnboardingError: Error {
        case invalidUrl
        case requestToken(Error)
        case internalError
    }

    enum State: AutoEquatable {
        case openAuthorizeURL(URL)
        case token(Token)
    }

    typealias URLResult = (code: String, state: String)
    private let signingToken = Signal<URLResult, OnboardingError>.pipe()

    private let credentials: Credentials
    private let redirectURI: String
    private let tokenFactory: StateTokenFactory
    
    init(credentials: Credentials, redirectURI: String, tokenFactory: StateTokenFactory) {
        self.credentials = credentials
        self.redirectURI = redirectURI
        self.tokenFactory = tokenFactory
    }
    
    func onboard() -> SignalProducer<State, OnboardingError> {
        let stateToken = tokenFactory.generate()
        let authURL = self.url(with: stateToken)
        
        let code = SignalProducer(signingToken.output)
            .map(Optional.some)
            .prefix(value: nil)
        
        let url = SignalProducer<URL, OnboardingError>(value: authURL)
        
        return SignalProducer.combineLatest(url, code).flatMap(.concat) { url, result -> SignalProducer<State, OnboardingError> in
            guard let result = result else {
                return SignalProducer(value: State.openAuthorizeURL(url))
            }
            
            return self.requestToken(code: result.code , state: result.state).map(State.token)
        }
    }
    
    func finalizeAuthentication(with url: URL) {
        guard let comps = NSURLComponents(url: url, resolvingAgainstBaseURL: true) else {
            signingToken.input.send(error: .invalidUrl)
            return
        }
        
        guard let code = comps.queryItems?.filter({ $0.name == "code" }).first?.value else {
            signingToken.input.send(error: .invalidUrl)
            return
        }
        
        guard let state = comps.queryItems?.filter({ $0.name == "state" }).first?.value else {
            signingToken.input.send(error: .invalidUrl)
            return
        }
        
        
        signingToken.input.send(value: (code, state))
    }
    
    func url(with state: Token) -> URL {
        let args: [(String, String)] = [
            ("client_id", credentials.clientId),
            ("redirect_uri", redirectURI),
            ("scope", "user repo"),
            ("state", state.value),
            ("allow_signup", "false"),
        ]
        
        var comps = URLComponents(url: URL(string: "https://github.com/login/oauth/authorize")!, resolvingAgainstBaseURL: true)!
        comps.queryItems = args.map(URLQueryItem.init)
        
        return comps.url!
    }
    
    func requestToken(code: String, state: String) -> SignalProducer<Token, OnboardingError> {
        let params: [(String, String)] = [
            ("client_id", credentials.clientId),
            ("client_secret", credentials.clientSecret),
            ("code", code),
            ("redirect_uri", redirectURI),
            ("state", state)
        ]
        
        var comps = URLComponents(url: URL(string: "https://github.com/login/oauth/access_token")!, resolvingAgainstBaseURL: true)!
        comps.queryItems = params.map(URLQueryItem.init)
        
        var request = URLRequest(url: comps.url!)
        request.allHTTPHeaderFields = ["Accept": "application/json"]
        
        let task = URLSession.shared.reactive.data(with: request)
            .mapError(OnboardingError.requestToken)
        
        return task.attemptMap { data, response in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let payload = json as? [String: Any] else {
                return .failure(OnboardingError.internalError)
            }
            
            guard let token = payload["access_token"] as? String else {
                return .failure(OnboardingError.internalError)
            }
            
            return .success(Token(value: token))
        }
    }
}
