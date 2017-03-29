//
//  RepositoryInfoTests.swift
//  Tentacle
//
//  Created by Romain Pouclet on 2016-08-02.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import XCTest
@testable import Tentacle
import Argo

class RepositoryInfoTests: XCTestCase {

    func testUserRepositoryInfoAreEquals() {
        let palleasOpensource = User(
            id: "15802020",
            login: "Palleas-opensource",
            url: URL(string: "https://github.com/Palleas-opensource")!,
            avatarURL: URL(string: "https://avatars.githubusercontent.com/u/15802020?v=3")!,
            type: .user
        )

        let expected = [
            RepositoryInfo(
                id: "59615946",
                owner: palleasOpensource,
                name: "Sample-repository",
                nameWithOwner: "Palleas-opensource/Sample-repository",
                body: "",
                url: URL(string: "https://github.com/Palleas-opensource/Sample-repository")!,
                homepage: nil,
                isPrivate: false,
                isFork: false,
                forksCount: 0,
                stargazersCount: 0,
                watchersCount: 0,
                openIssuesCount: 2,
                pushedAt: DateFormatter.iso8601.date(from: "2016-07-14T01:40:08Z")!,
                createdAt: DateFormatter.iso8601.date(from: "2016-05-24T23:38:17Z")!,
                updatedAt: DateFormatter.iso8601.date(from: "2016-05-24T23:38:17Z")!
            )
        ]

        let decoded: [RepositoryInfo] = Fixture.RepositoriesForUser.RepositoriesForPalleasOpensource.decode()!

        XCTAssertEqual(decoded, expected)
    }

    func testOrganizationRepositoryAreEqual() {
        let raccommunity = User(
            id: "18710012",
            login: "RACCommunity",
            url: URL(string: "https://github.com/RACCommunity")!,
            avatarURL: URL(string: "https://avatars.githubusercontent.com/u/18710012?v=3")!,
            type: .organization
        )

        let expected = [
            RepositoryInfo(
                id: "35350514",
                owner: raccommunity,
                name: "Rex",
                nameWithOwner: "RACCommunity/Rex",
                body: "ReactiveCocoa Extensions",
                url: URL(string: "https://github.com/RACCommunity")!,
                homepage: nil,
                isPrivate: false,
                isFork: false,
                forksCount: 33,
                stargazersCount: 193,
                watchersCount: 193,
                openIssuesCount: 16,
                pushedAt: DateFormatter.iso8601.date(from: "2016-08-01T08:15:31Z")!,
                createdAt: DateFormatter.iso8601.date(from: "2015-05-10T00:15:08Z")!,
                updatedAt: DateFormatter.iso8601.date(from: "2016-07-31T12:12:36Z")!
            ),
            RepositoryInfo(
                id: "49464897",
                owner: raccommunity,
                name: "RACNest",
                nameWithOwner: "RACCommunity/RACNest",
                body: "RAC + MVVM examples :mouse::mouse::mouse:",
                url: URL(string: "https://github.com/RACCommunity/RACNest")!,
                homepage: nil,
                isPrivate: false,
                isFork: false,
                forksCount: 6,
                stargazersCount: 82,
                watchersCount: 82,
                openIssuesCount: 3,
                pushedAt: DateFormatter.iso8601.date(from: "2016-04-27T07:22:45Z")!,
                createdAt: DateFormatter.iso8601.date(from: "2016-01-12T01:00:02Z")!,
                updatedAt: DateFormatter.iso8601.date(from: "2016-08-02T16:07:39Z")!
            ),
            RepositoryInfo(
                id: "57858100",
                owner: raccommunity,
                name: "contributors",
                nameWithOwner: "RACCommunity/contributors",
                body: "ReactiveCocoa's Community Guidelines",
                url: URL(string: "https://github.com/RACCommunity")!,
                homepage: nil,
                isPrivate: false,
                isFork: false,
                forksCount: 1,
                stargazersCount: 16,
                watchersCount: 16,
                openIssuesCount: 4,
                pushedAt: DateFormatter.iso8601.date(from: "2016-05-02T10:35:31Z")!,
                createdAt: DateFormatter.iso8601.date(from: "2016-05-02T00:27:44Z")!,
                updatedAt: DateFormatter.iso8601.date(from: "2016-07-27T11:39:23Z")!
            ),
            RepositoryInfo(
                id: "59124784",
                owner: raccommunity,
                name: "racurated",
                nameWithOwner: "RACCommunity/racurated",
                body: "Curated list of ReactiveCocoa projects.",
                url: URL(string: "https://github.com/RACCommunity/racurated")!,
                homepage: URL(string: "https://raccommunity.github.io/racurated/")!,
                isPrivate: false,
                isFork: false,
                forksCount: 0,
                stargazersCount: 5,
                watchersCount: 5,
                openIssuesCount: 0,
                pushedAt: DateFormatter.iso8601.date(from: "2016-06-07T23:47:44Z")!,
                createdAt: DateFormatter.iso8601.date(from: "2016-05-18T14:47:59Z")!,
                updatedAt: DateFormatter.iso8601.date(from: "2016-07-27T11:39:11Z")!
            ),
            RepositoryInfo(
                id: "75979247",
                owner: raccommunity,
                name: "ReactiveCollections",
                nameWithOwner: "RACCommunity/ReactiveCollections",
                body: "Reactive collections for Swift using ReactiveSwift 🚗 🚕 🚙 ",
                url: URL(string: "https://github.com/RACCommunity/ReactiveCollections")!,
                homepage: nil,
                isPrivate: false,
                isFork: false,
                forksCount: 0,
                stargazersCount: 6,
                watchersCount: 6,
                openIssuesCount: 7,
                pushedAt: DateFormatter.iso8601.date(from: "2016-12-21T19:32:19Z")!,
                createdAt: DateFormatter.iso8601.date(from: "2016-12-08T22:08:36Z")!,
                updatedAt: DateFormatter.iso8601.date(from: "2016-12-21T17:53:43Z")!)
        ]

        let decoded: [RepositoryInfo] = Fixture.RepositoriesForOrganization.RepositoriesForRACCommunity.decode()!

        XCTAssertEqual(decoded, expected)
    }

}
