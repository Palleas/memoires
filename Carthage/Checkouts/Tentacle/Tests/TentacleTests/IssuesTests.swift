//
//  IssuesTests.swift
//  Tentacle
//
//  Created by Romain Pouclet on 2016-05-24.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Argo
@testable import Tentacle
import XCTest

class IssuesTests: XCTestCase {
    
    func testDecodedPalleasOpensourceIssues() {
        let palleasOpensource = User(
            id: "15802020",
            login: "Palleas-opensource",
            url: URL(string: "https://github.com/Palleas-opensource")!,
            avatarURL: URL(string: "https://avatars.githubusercontent.com/u/15802020?v=3")!,
            type: .user
        )

        let shipItMilestone = Milestone(
            id: "1881390",
            number: 1,
            state: .open,
            title: "Release this app",
            body: "That'd be cool",
            creator: palleasOpensource,
            openIssueCount: 1,
            closedIssueCount: 0,
            createdAt: DateFormatter.iso8601.date(from: "2016-07-13T16:56:48Z")!,
            updatedAt: DateFormatter.iso8601.date(from: "2016-07-13T16:56:57Z")!,
            closedAt: nil,
            dueOn: DateFormatter.iso8601.date(from: "2016-07-25T04:00:00Z")!,
            url: URL(string: "https://api.github.com/repos/Palleas-opensource/Sample-repository/milestones/1")!
        )

        let updateReadmePullRequest = PullRequest(
            url: URL(string: "https://github.com/Palleas-opensource/Sample-repository/pull/3")!,
            diffURL: URL(string: "https://github.com/Palleas-opensource/Sample-repository/pull/3.diff")!,
            patchURL: URL(string: "https://github.com/Palleas-opensource/Sample-repository/pull/3.patch")!
        )

        let expected = [
            Issue(id: "165458041",
                url: URL(string: "https://github.com/Palleas-opensource/Sample-repository/pull/3"),
                number: 3,
                state: .open,
                title: "Add informations in Readme",
                body: "![Giphy](http://media2.giphy.com/media/jxhJ8ylaYIPbG/giphy.gif)\n",
                user: palleasOpensource,
                labels: [],
                assignees: [],
                milestone: nil,
                isLocked: false,
                commentCount: 0,
                pullRequest: updateReadmePullRequest,
                closedAt: nil,
                createdAt:  DateFormatter.iso8601.date(from: "2016-07-14T01:40:08Z")!,
                updatedAt:  DateFormatter.iso8601.date(from: "2016-07-14T01:40:08Z")!),
            Issue(id: "156633109",
                url: URL(string: "https://github.com/Palleas-opensource/Sample-repository/issues/1")!,
                number: 1,
                state: .open,
                title: "This issue is open",
                body: "Issues are pretty cool.\n",
                user: palleasOpensource,
                labels: [
                    Label(
                        name: "bug",
                        color: Color(hex: "ee0701")
                    ),
                    Label(
                        name: "duplicate",
                        color: Color(hex: "cccccc")
                    ),
                    Label(
                        name: "enhancement",
                        color: Color(hex: "84b6eb")
                    )
                ],
                assignees: [palleasOpensource],
                milestone: shipItMilestone,
                isLocked: false,
                commentCount: 2,
                pullRequest: nil,
                closedAt: nil,
                createdAt: DateFormatter.iso8601.date(from: "2016-05-24T23:38:39Z")!,
                updatedAt: DateFormatter.iso8601.date(from: "2016-07-27T01:29:31Z")!
            )
        ]

        let issues: [Issue]? = Fixture.IssuesInRepository.PalleasOpensource.decode()

        XCTAssertEqual(issues!, expected)
    }
}
