//
//  ColorTests.swift
//  Tentacle
//
//  Created by Romain Pouclet on 2016-07-19.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import XCTest
@testable import Tentacle

class ColorTests: XCTestCase {

    func testColorsAreProperlyDecoded() {
        XCTAssertEqual(Color(hex: "ffffff"), Color(red: 1, green: 1, blue: 1, alpha: 1))
        XCTAssertEqual(Color(hex: "ff0000"), Color(red: 1, green: 0, blue: 0, alpha: 1))
        XCTAssertEqual(Color(hex: "00ff00"), Color(red: 0, green: 1, blue: 0, alpha: 1))
        XCTAssertEqual(Color(hex: "0000ff"), Color(red: 0, green: 0, blue: 1, alpha: 1))
        XCTAssertEqual(Color(hex: "000000"), Color(red: 0, green: 0, blue: 0, alpha: 1))
    }

}
