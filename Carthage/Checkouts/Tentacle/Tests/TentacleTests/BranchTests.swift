//
//  BranchTests.swift
//  Tentacle
//
//  Created by Romain Pouclet on 2017-02-15.
//  Copyright © 2017 Matt Diephouse. All rights reserved.
//

import XCTest
@testable import Tentacle

class BranchTests: XCTestCase {
    
    func testDecodingBranches() {
        let expected = [
            Branch(name: "debuggin", sha: SHA(hash: "117775803ff583c467dac3cd2c923b8d3f7d1869")),
            Branch(name: "master", sha: SHA(hash: "567f8849cddadcd2469bafcad9d4f700ba4df881")),
            Branch(name: "playground", sha: SHA(hash: "131709d54e1157699e44300cb9b9f8d22f2807e7"))
        ]

        XCTAssertEqual(Fixture.BranchesForRepository.BranchesInReactiveTask.decode()!, expected)
    }
}
