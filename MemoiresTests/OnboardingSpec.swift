import Quick
import Nimble
@testable import Memoires

class OnboardingSpec: QuickSpec {
    override func spec() {
        describe("OnboardingController") {
            var onboarding: OnboardingController<StaticStringTokenFactory>!
            let factory = StaticStringTokenFactory(wrapped: "state-is-evil")
            
            beforeEach {
                onboarding = OnboardingController(credentials: .init(clientId: "client-id", clientSecret: "client-secret"), redirectURI: "memoires://auth", tokenFactory: factory)
            }
            
            afterEach {
                onboarding = nil
            }
            
            it("builds an URL to redirect the user to") {
                let url = URL(string: "https://github.com/login/oauth/authorize?client_id=client-id&redirect_uri=memoires://auth&scope=user%20repo&state=state-is-evil&allow_signup=false")!
                
                let initialState = onboarding.onboard().first()!.value!
                expect(initialState) == OnboardingController.State.openAuthorizeURL(url)
            }
            
            it("handles auth redirect") {
                
            }

            it("rejects invalid completion URL") {
                
            }
            
            it("request a token") {
                
            }
        }
    }
}

final class StaticStringTokenFactory: StateTokenFactory {
    let wrapped: String
    
    init(wrapped: String) {
        self.wrapped = wrapped
    }
    
    func generate() -> String {
        return wrapped
    }
}
