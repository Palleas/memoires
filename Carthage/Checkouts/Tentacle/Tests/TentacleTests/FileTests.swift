//
//  FileTests.swift
//  Tentacle
//
//  Created by Romain Pouclet on 2017-01-25.
//  Copyright © 2017 Matt Diephouse. All rights reserved.
//

@testable import Tentacle
import XCTest
import Argo

class FileTests: XCTestCase {
    
    func testFileEncoding() {
        let palleas = Author(name: "Romain Pouclet", email: "romain.pouclet@gmail.com")

        let file = File(
            message: "Added file",
            committer: palleas,
            author: palleas,
            content: "This is the content of my file".data(using: .utf8)!,
            branch: "master"
        )

        let expected: JSON = .object([
            "message": .string("Added file"),
            "content": .string("This is the content of my file".data(using: .utf8)!.base64EncodedString()),
            "committer": .object([
                "name": .string("Romain Pouclet"),
                "email": .string("romain.pouclet@gmail.com")
            ]),
            "author": .object([
                "name": .string("Romain Pouclet"),
                "email": .string("romain.pouclet@gmail.com")
            ]),
            "branch": .string("master")
        ])

        let encoded = file.encode()
        XCTAssertEqual(expected, encoded)
    }

    func testFileEncodingWithoutOptionalArgs() {
        let file = File(
            message: "Added file",
            committer: nil,
            author: nil,
            content: "This is the content of my file".data(using: .utf8)!,
            branch: nil
        )

        let expected: JSON = .object([
            "message": .string("Added file"),
            "content": .string("This is the content of my file".data(using: .utf8)!.base64EncodedString()),
        ])

        let encoded = file.encode()
        XCTAssertEqual(expected, encoded)

    }
}
