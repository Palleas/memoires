//
//  PullRequest.swift
//  Tentacle
//
//  Created by Romain Pouclet on 2016-05-23.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

public struct PullRequest: CustomStringConvertible {
    /// The URL to view the Pull Request is an browser
    public let url: URL

    /// The URL to the diff showing all the changes included in this pull request
    public let diffURL: URL

    /// The URL to a downloadable patch for this pull request
    public let patchURL: URL

    public var description: String {
        return url.absoluteString
    }
}

extension PullRequest: Hashable {
    public static func ==(lhs: PullRequest, rhs: PullRequest) -> Bool {
        return lhs.url == rhs.url
    }

    public var hashValue: Int {
        return url.hashValue
    }
}

extension PullRequest: ResourceType {
    public static func decode(_ j: JSON) -> Decoded<PullRequest> {
        return curry(self.init)
            <^> (j <| "html_url" >>- toURL)
            <*> (j <| "diff_url" >>- toURL)
            <*> (j <| "patch_url" >>- toURL)

    }
}
