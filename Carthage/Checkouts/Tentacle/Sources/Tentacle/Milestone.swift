//
//  Milestone.swift
//  Tentacle
//
//  Created by Romain Pouclet on 2016-05-23.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

public struct Milestone: CustomStringConvertible {
    public enum State: String {
        case open = "open"
        case closed = "closed"
    }

    /// The ID of the milestone
    public let id: String

    /// The number of the milestone in the repository it belongs to
    public let number: Int

    /// The state of the Milestone, open or closed
    public let state: State

    /// The title of the milestone
    public let title: String

    /// The description of the milestone
    public let body: String

    /// The user who created the milestone
    public let creator: User

    /// The number of the open issues in the milestone
    public let openIssueCount: Int

    /// The number of closed issues in the milestone
    public let closedIssueCount: Int

    /// The date the milestone was created
    public let createdAt: Date

    /// The date the milestone was last updated at
    public let updatedAt: Date

    /// The date the milestone was closed at, if ever
    public let closedAt: Date?

    /// The date the milestone is due on
    public let dueOn: Date?

    /// The URL to view this milestone in a browser
    public let url: URL

    public var description: String {
        return title
    }
}

extension Milestone: Hashable {
    public static func ==(lhs: Milestone, rhs: Milestone) -> Bool {
        return lhs.id == rhs.id
    }

    public var hashValue: Int {
        return id.hashValue
    }
}

internal func toMilestoneState(_ string: String) -> Decoded<Milestone.State> {
    if let state = Milestone.State(rawValue: string) {
        return .success(state)
    } else {
        return .failure(.custom("Milestone state is invalid"))
    }
}

extension Milestone: ResourceType {
    public static func decode(_ j: JSON) -> Decoded<Milestone> {
        let f = curry(self.init)

        let ff = f
            <^> (j <| "id" >>- toString)
            <*> j <| "number"
            <*> (j <| "state" >>- toMilestoneState)
            <*> j <| "title"
            <*> j <| "description"
        let fff = ff
            <*> j <| "creator"
            <*> j <| "open_issues"
            <*> j <| "closed_issues"
            <*> (j <| "created_at" >>- toDate)
            <*> (j <| "updated_at" >>- toDate)
        return fff
            <*> (j <|? "closed_at" >>- toOptionalDate)
            <*> (j <|? "due_on" >>- toOptionalDate)
            <*> (j <| "html_url" >>- toURL)
    }
}
