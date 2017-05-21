import XCTest

class MemoiresUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLogin() {
        XCUIApplication().buttons["Authenticate now with Github"].tap()
    }
    
}
