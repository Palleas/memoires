import XCTest
import MemoiresKit

class MemoiresUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchEnvironment = ["Environment": Environment.testing.rawValue]
        app.launch()
    }
    
    func testLogin() {
        XCUIApplication().buttons["Authenticate now with Github"].tap()
    }
    
}
