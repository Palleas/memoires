import Foundation
import ReactiveSwift

protocol StateTokenFactory {
    associatedtype TokenType: CustomStringConvertible
    
    func generate() -> TokenType
}

final class OnboardingController<F: StateTokenFactory>{
    struct Credentials {
        let clientId: String
        let clientSecret: String
    }
    
    enum OnboardingError: Error {
        
    }

    enum State: Equatable {
        case openAuthorizeURL(URL)
        
        static func ==(lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case let (.openAuthorizeURL(url1), .openAuthorizeURL(url2)):
                return url1 == url2
            default:
                return false
            }
        }
    }
    
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

        return SignalProducer(value: .openAuthorizeURL(authURL))
    }
    
    func finalizeAuthentication(with url: URL) {
        
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
