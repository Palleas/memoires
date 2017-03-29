//
//  ArgoExtensionsTests.swift
//  Tentacle
//
//  Created by Romain Pouclet on 2017-01-25.
//  Copyright © 2017 Matt Diephouse. All rights reserved.
//

import XCTest
import Argo
@testable import Tentacle

class ArgoExtensionsTests: XCTestCase {

    func testNullDecoding() {
        let null: JSON = .null
        XCTAssertTrue(null.JSONObject() is NSNull)
    }

    func testStringDecoding() {
        let name: JSON = .string("Romain")
        XCTAssertEqual(name.JSONObject() as! String, "Romain")
    }

    func testNumberDecoding() {
        let answer: JSON = .number(42)
        XCTAssertEqual(answer.JSONObject() as! NSNumber, 42)
    }

    func testDecodingArray() {
        let array: JSON = .array([.string("Romain")])
        XCTAssertEqual(array.JSONObject() as! [String], ["Romain"])
    }

    func testDecodingBool() {
        let yes: JSON = .bool(true)
        XCTAssertTrue(yes.JSONObject() as! Bool)
    }

    func testDecodingObject() {
        let object: JSON = .object(["fullname": .string("Romain Pouclet"), "email": .string("romain.pouclet@gmail.com")])
        XCTAssertEqual(object.JSONObject() as! [String: String], ["fullname": "Romain Pouclet", "email": "romain.pouclet@gmail.com"])
    }
}
