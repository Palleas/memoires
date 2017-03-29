//
//  Commit.swift
//  Tentacle
//
//  Created by Romain Pouclet on 2016-12-22.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

public struct Commit {
    /// SHA of the commit
    public let sha: SHA

    /// Author of the commit
    public let author: Author

    /// Committer of the commit
    public let committer: Author

    /// Comit Message
    public let message: String

    /// URL to see the commit in a browser
    public let url: URL

    /// Parents commits
    public let parents: [Parent]

    public struct Parent {
        /// URL to see the parent commit in a browser
        public let url: URL

        /// SHA of the parent commit
        public let sha: SHA
    }

    public struct Author {
        /// Date the author made the commit
        public let date: Date
        /// Name of the author
        public let name: String
        /// Email of the author
        public let email: String
    }
}

extension Commit: ResourceType {
    public var hashValue: Int {
        return sha.hashValue
    }

    public static func ==(lhs: Commit, rhs: Commit) -> Bool {
        return lhs.sha == rhs.sha
    }

    public static func decode(_ j: JSON) -> Decoded<Commit> {
        return curry(Commit.init)
            <^> (j <| "sha" >>- toSHA)
            <*> j <| "author"
            <*> j <| "committer"
            <*> j <| "message"
            <*> (j <| "url" >>- toURL)
            <*> j <|| "parents"
    }
}

extension Commit.Author: ResourceType {
    public static func decode(_ j: JSON) -> Decoded<Commit.Author> {
        return curry(Commit.Author.init)
            <^> (j <| "date" >>- toDate)
            <*> j <| "name"
            <*> j <| "email"
    }

    public var hashValue: Int {
        return date.hashValue ^ name.hashValue ^ email.hashValue
    }

    public static func ==(lhs: Commit.Author, rhs: Commit.Author) -> Bool {
        return lhs.date == rhs.date
            && lhs.name == rhs.name
            && lhs.email == rhs.email
    }
}

extension Commit.Parent: ResourceType {
    public static func decode(_ j: JSON) -> Decoded<Commit.Parent> {
        return curry(Commit.Parent.init)
            <^> (j <| "url" >>- toURL)
            <*> (j <| "sha" >>- toSHA)
    }

    public var hashValue: Int {
        return sha.hashValue ^ url.hashValue
    }

    public static func ==(lhs: Commit.Parent, rhs: Commit.Parent) -> Bool {
        return lhs.sha == rhs.sha
            && lhs.url == rhs.url
    }
}

