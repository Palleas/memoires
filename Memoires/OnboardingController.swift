import Foundation
import ReactiveSwift

struct Credentials {
    let clientId: String
    let clientSecret: String
}

struct Token {
    let value: String
}

final class OnboardingController<F: StateTokenFactory>{

    enum OnboardingError: Error {
        case invalidUrl
        case fetchTokenError
    }

    enum State: Equatable {
        case openAuthorizeURL(URL)
        case fetchedToken(Token)
        
        static func ==(lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case let (.openAuthorizeURL(url1), .openAuthorizeURL(url2)):
                return url1 == url2
            case let (.fetchedToken(token1), .fetchedToken(token2)):
                return token1 == token2
            default:
                return false
            }
        }
    }

    typealias URLResult = (code: String, state: String)
    private let signingToken = Signal<URLResult, OnboardingError>.pipe()

    private let credentials: Credentials
    private let redirectURI: String
    private let tokenFactory: F
    
    init(credentials: Credentials, redirectURI: String, tokenFactory: F) {
        self.credentials = credentials
        self.redirectURI = redirectURI
        self.tokenFactory = tokenFactory
    }
    
    func onboard() -> SignalProducer<State, OnboardingError> {
        let stateToken = tokenFactory.generate()
        let authURL = self.url(state: stateToken)

        let resultProducer = SignalProducer(signingToken.output).map(Optional.some).prefix(value: nil)
        let urlProducer = SignalProducer<State, OnboardingError>(value: .openAuthorizeURL(authURL))

        let combined = SignalProducer.combineLatest(resultProducer, urlProducer)
        
        return combined.flatMap(.latest) { result, url -> SignalProducer<State, OnboardingError> in
            guard let (code, state) = result else {
                return SignalProducer(value: .openAuthorizeURL(authURL))
            }
            
            return self.fetchToken(with: code, state: state).map { State.fetchedToken($0) }
        }
    }
    
    func fetchToken(with code: String, state: String) -> SignalProducer<Token, OnboardingError> {
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
            .mapError { _ in OnboardingError.fetchTokenError }
        
        return task.attemptMap { data, response in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            
            guard let payload = json as? [String: Any] else {
                return .failure(OnboardingError.fetchTokenError)
            }
            
            guard let token = payload["access_token"] as? String else {
                return .failure(OnboardingError.fetchTokenError)
            }
            
            return .success(Token(value: token))
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
    
    func url(state: F.TokenType) -> URL {
        let args: [(String, String)] = [
            ("client_id", credentials.clientId),
            ("redirect_uri", redirectURI),
            ("scope", "user repo"),
            ("state", state.description),
            ("allow_signup", "false"),
        ]
        
        var comps = URLComponents(url: URL(string: "https://github.com/login/oauth/authorize")!, resolvingAgainstBaseURL: true)!
        comps.queryItems = args.map(URLQueryItem.init)
        
        return comps.url!
    }
}

extension Token: Equatable {
    static func ==(lhs: Token, rhs: Token) -> Bool {
        return lhs.value == rhs.value
    }
}
