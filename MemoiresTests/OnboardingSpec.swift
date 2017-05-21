import Quick
import Nimble
import OHHTTPStubs

@testable import Memoires

class OnboardingSpec: QuickSpec {
    override func spec() {
        describe("OnboardingController") {
            var onboarding: OnboardingController!
            let factory = StaticStringTokenFactory(wrapped: "state-is-evil")
            
            beforeEach {
                onboarding = OnboardingController(credentials: .init(clientId: "client-id", clientSecret: "client-secret"), redirectURI: "memoires://auth", tokenFactory: factory)
            }
            
            afterEach {
                onboarding = nil
                
                OHHTTPStubs.removeAllStubs()
            }
            
            it("builds an URL to redirect the user to") {
                let url = URL(string: "https://github.com/login/oauth/authorize?client_id=client-id&redirect_uri=memoires://auth&scope=user%20repo&state=state-is-evil&allow_signup=false")!
                
                let initialState = onboarding.onboard().first()?.value
                expect(initialState) == OnboardingController.State.openAuthorizeURL(url)
            }
            
            it("handles auth redirect") {
                let redirectURL = URL(string: "memoires://auth?code=github-auth-code&state=state-is-evil")!
                
                onboarding.finalizeAuthentication(with: redirectURL)
                
                let state = onboarding.onboard().skip(first: 1).first()?.value
                
                expect(state) == OnboardingController.State.token(Token(value: "fetched-token"))
            }

            it("rejects invalid completion URL") {
                
            }
            
            it("request a token") {
                stub(condition: isHost("github.com"), response: { _ -> OHHTTPStubsResponse in
                    let path = Bundle(for: type(of: self)).path(forResource: "access_token", ofType: "json", inDirectory: "fixtures")!
                    
                    return fixture(filePath: path, headers: nil)
                })
                
                let token = onboarding
                    .requestToken(code: "some-code", state: "state")
                    .first()?
                    .value
                
                expect(token) == Token(value: "e72e16c7e42f292c6912e7710c838347ae178b4a")
            }
        }
    }
}

final class StaticStringTokenFactory: StateTokenFactory {
    let wrapped: String
    
    init(wrapped: String) {
        self.wrapped = wrapped
    }
    
    func generate() -> Token {
        return Token(value: wrapped)
    }
}
