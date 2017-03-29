//
//  Comment.swift
//  Tentacle
//
//  Created by Romain Pouclet on 2016-07-27.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Foundation
import Curry
import Argo
import Runes

public struct Comment: CustomStringConvertible {

    /// The id of the issue
    public let id: String
    /// The URL to view this comment in a browser
    public let url: URL
    /// The date this comment was created at
    public let createdAt: Date
    /// The date this comment was last updated at
    public let updatedAt: Date
    /// The body of the comment
    public let body: String
    /// The author of this comment
    public let author: User
    
    public var description: String {
        return body
    }
}

extension Comment: Hashable {
    public static func ==(lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id
            && lhs.url == rhs.url
            && lhs.body == rhs.body
    }

    public var hashValue: Int {
        return id.hashValue
    }
}

extension Comment: ResourceType {
    public static func decode(_ j: JSON) -> Decoded<Comment> {
        let f = curry(Comment.init)

        return f
            <^> (j <| "id" >>- toString)
            <*> (j <| "html_url" >>- toURL)
            <*> (j <| "created_at" >>- toDate)
            <*> (j <| "updated_at" >>- toDate)
            <*> j <| "body"
            <*> j <| "user"
    }
}
