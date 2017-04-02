//
//  MemoiresUITests.swift
//  MemoiresUITests
//
//  Created by Romain Pouclet on 2017-03-28.
//  Copyright © 2017 Perfectly-Cooked. All rights reserved.
//

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
