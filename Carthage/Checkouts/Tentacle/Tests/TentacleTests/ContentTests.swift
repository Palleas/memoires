//
//  ContentTests.swift
//  Tentacle
//
//  Created by Romain Pouclet on 2016-11-28.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import XCTest
import Argo
@testable import Tentacle

class ContentTests: XCTestCase {

    func testDecodedFile() {
        let expected: Content = .file(Content.File(
            content: .file(size: 19, downloadURL: URL(string: "https://raw.githubusercontent.com/Palleas-opensource/Sample-repository/master/README.md")!),
            name: "README.md",
            path: "README.md",
            sha: "28ec72028c4ae47de689964a23ebb223f10cfe80",
            url: URL(string: "https://github.com/Palleas-opensource/Sample-repository/blob/master/README.md")!
        ))

        XCTAssertEqual(Fixture.FileForRepository.ReadMeForSampleRepository.decode()!, expected)
    }

    func testDecodedDirectory() {
        let expected: Content = .directory([
            Content.File(
                content: .directory,
                name: "Directory",
                path: "Tools/Directory",
                sha: "5bfad2b3f8e483b6b173d8aaff19597e84626f15",
                url: URL(string: "https://github.com/Palleas-opensource/Sample-repository/tree/master/Tools/Directory")!
            ),
            Content.File(
                content: .file(size: 18, downloadURL: URL(string: "https://raw.githubusercontent.com/Palleas-opensource/Sample-repository/master/Tools/README.markdown")!),
                name: "README.markdown",
                path: "Tools/README.markdown",
                sha: "c3eb8708a0a5aaa4f685aab24ef6403fbfd28efc",
                url: URL(string: "https://github.com/Palleas-opensource/Sample-repository/blob/master/Tools/README.markdown")!
            ),
            Content.File(
                content: .submodule(url: nil),
                name: "Tentacle",
                path: "Tools/Tentacle",
                sha: "7a84505a3c553fd8e2879cfa63753b0cd212feb8",
                url: URL(string: "https://github.com/mdiep/Tentacle/tree/7a84505a3c553fd8e2879cfa63753b0cd212feb8")!
            ),
            Content.File(
                content: .symlink(target: nil, downloadURL: URL(string: "https://raw.githubusercontent.com/Palleas-opensource/Sample-repository/master/Tools/say")!),
                name: "say",
                path: "Tools/say",
                sha: "1e3f1fd0bc1f65cf4701c217f4d1fd9a3cd50721",
                url: URL(string: "https://github.com/Palleas-opensource/Sample-repository/blob/master/Tools/say")!
            )
        ])

        XCTAssertEqual(Fixture.FileForRepository.DirectoryInSampleRepository.decode()!, expected)
    }

    func testDecodedSubmodule() {
        let expected: Content = .file(Content.File(
            content: .submodule(url: "https://github.com/ReactiveCocoa/ReactiveSwift.git"),
            name: "ReactiveSwift",
            path: "Carthage/Checkouts/ReactiveSwift",
            sha: "df08a05210157143d7f06c87feb6f9ad3c7603d6",
            url: URL(string: "https://github.com/ReactiveCocoa/ReactiveSwift/tree/df08a05210157143d7f06c87feb6f9ad3c7603d6")!
        ))

        XCTAssertEqual(Fixture.FileForRepository.SubmoduleInTentacle.decode()!, expected)
    }

    func testDecodedSymlink() {
        let expected: Content = .file(Content.File(
            content: .symlink(target: "/usr/bin/say", downloadURL: URL(string: "https://raw.githubusercontent.com/Palleas-opensource/Sample-repository/master/Tools/say")),
            name: "say",
            path: "Tools/say",
            sha: "1e3f1fd0bc1f65cf4701c217f4d1fd9a3cd50721",
            url: URL(string: "https://github.com/Palleas-opensource/Sample-repository/blob/master/Tools/say")!
        ))

        XCTAssertEqual(Fixture.FileForRepository.SymlinkInSampleRepository.decode()!, expected)
    }
}
