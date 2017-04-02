import Quick
import Nimble
@testable import Memoires

class OnboardingSpec: QuickSpec {
    override func spec() {
        describe("OnboardingController") {
            it("builds an URL to redirect the user to") {
                let credentials = OnboardingController(credentials: .init(clientId: "", clientSecret: ""))
            }
            
            it("rejects invalid completion URL") {
                
            }
            
            it("request a token") {
                
            }
        }
    }
}
