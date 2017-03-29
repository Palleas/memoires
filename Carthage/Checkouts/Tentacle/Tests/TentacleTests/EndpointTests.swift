//
//  EndpointTests.swift
//  Tentacle
//
//  Created by Romain Pouclet on 2017-02-05.
//  Copyright © 2017 Matt Diephouse. All rights reserved.
//

import XCTest
@testable import Tentacle

class EndpointTests: XCTestCase {
    
    func testEndpointProvidesQueryItemsWhenNeeded() {
        let endpoint: Client.Endpoint = .content(owner: "palleas", repository: "romain-pouclet.com", path: "config.yml", ref: "sample-branch")
        XCTAssertEqual([URLQueryItem(name: "ref", value: "sample-branch")], endpoint.queryItems)

        let endpointWithoutRef: Client.Endpoint = .content(owner: "palleas", repository: "romain-pouclet.com", path: "config.yml", ref: nil)
        XCTAssertEqual(0, endpointWithoutRef.queryItems.count)
    }

}
