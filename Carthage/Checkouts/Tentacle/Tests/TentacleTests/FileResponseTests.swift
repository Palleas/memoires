//
//  FileResponseTests.swift
//  Tentacle
//
//  Created by POUCLET, Romain (MTL) on 2016-12-24.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import XCTest
import Argo
@testable import Tentacle

class FileResponseTests: XCTestCase {

    func testDecodedFileResponse() {
        #if SWIFT_PACKAGE
            let url = URL(fileURLWithPath: #file)
                .deletingLastPathComponent()
                .appendingPathComponent("Fixtures")
                .appendingPathComponent("create-file-sample-response.data")
        #else
            let url = Bundle(for: type(of: self)).url(forResource: "create-file-sample-response", withExtension: "data")!
        #endif
        let data = try! Data(contentsOf: url)
        let json = JSON(try! JSONSerialization.jsonObject(with: data, options: []))

        let content = Content.file(Content.File(
            content: .file(size: 9, downloadURL: URL(string: "https://raw.githubusercontent.com/octocat/HelloWorld/master/notes/hello.txt")!),
            name: "hello.txt",
            path: "notes/hello.txt",
            sha: "95b966ae1c166bd92f8ae7d1c313e738c731dfc3", url: URL(string: "https://github.com/octocat/Hello-World/blob/master/notes/hello.txt")!
        ))

        let author = Commit.Author(
            date: DateFormatter.iso8601.date(from: "2014-11-07T22:01:45Z")!,
            name: "Scott Chacon",
            email: "schacon@gmail.com"
        )

        let commit = Commit(
            sha: SHA(hash: "7638417db6d59f3c431d3e1f261cc637155684cd"),
            author: author,
            committer: author,
            message: "my commit message",
            url: URL(string: "https://github.com/octocat/Hello-World/git/commit/7638417db6d59f3c431d3e1f261cc637155684cd")!,
            parents: [
                Commit.Parent(
                    url: URL(string: "https://github.com/octocat/Hello-World/git/commit/1acc419d4d6a9ce985db7be48c6349a0475975b5")!,
                    sha: SHA(hash: "1acc419d4d6a9ce985db7be48c6349a0475975b5")
                )
            ]
        )

        let expected = FileResponse(content: content, commit: commit)

        guard case let .success(decoded) = FileResponse.decode(json) else {
            XCTFail()
            return
        }

        XCTAssertEqual(expected, decoded)
    }
}
