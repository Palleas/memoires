//
//  RepositoryTests.swift
//  Tentacle
//
//  Created by Matt Diephouse on 3/20/16.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Tentacle
import XCTest

class RepositoryTests: XCTestCase {
    func testEquality() {
        let repo1 = Repository(owner: "mdiep", name: "Tentacle")
        let repo2 = Repository(owner: "mdiep", name: "TENTACLE")
        let repo3 = Repository(owner: "MDIEP", name: "Tentacle")
        XCTAssertEqual(repo1, repo2)
        XCTAssertEqual(repo1, repo3)
        XCTAssertEqual(repo1.hashValue, repo2.hashValue)
        XCTAssertEqual(repo1.hashValue, repo3.hashValue)
    }
}
