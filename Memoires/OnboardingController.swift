import Foundation
import ReactiveSwift
import ReactiveCocoa


final class OnboardingController {

    struct Credentials {
        let clientId: String
        let clientSecret: String
    }
    
    private let credentials: Credentials

    init(credentials: Credentials) {
        self.credentials = credentials
    }
    
    static func finalizeAuthentication(with url: URL) {
        
    }
    
}
