//
//  ServerTests.swift
//  Tentacle
//
//  Created by Matt Diephouse on 3/20/16.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

@testable import Tentacle
import XCTest

class ServerTests: XCTestCase {
    func testEquality() {
        let server1 = Server.enterprise(url: URL(string: "https://example.com")!)
        let server2 = Server.enterprise(url: URL(string: "https://EXAMPLE.COM")!)
        XCTAssertEqual(server1, server2)
        XCTAssertEqual(server1.hashValue, server2.hashValue)
    }
    
    func testEndpoint() {
        let dotCom = Server.dotCom
        XCTAssertEqual(dotCom.endpoint, "https://api.github.com")
        
        let enterprise = Server.enterprise(url: URL(string: "https://example.com")!)
        XCTAssertEqual(enterprise.endpoint, "https://example.com/api/v3")
    }
}
