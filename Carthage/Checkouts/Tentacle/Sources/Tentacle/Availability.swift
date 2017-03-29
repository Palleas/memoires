//
//  Availability.swift
//  Tentacle
//
//  Created by Syo Ikeda on 11/6/16.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Foundation
import ReactiveSwift

extension DateFormatter {
    @available(*, unavailable, renamed: "iso8601")
    @nonobjc public static var ISO8601: DateFormatter { fatalError() }
}

extension Issue {
    @available(*, unavailable, renamed: "isLocked")
    public var locked: Bool { return isLocked }
}

extension Release {
    @available(*, unavailable, renamed: "isDraft")
    public var draft: Bool { return isDraft }

    @available(*, unavailable, renamed: "isPrerelease")
    public var prerelease: Bool { return isPrerelease }
}

extension Release.Asset {
    @available(*, unavailable, renamed: "apiURL")
    public var APIURL: URL { fatalError() }
}

extension Client {
    @available(*, unavailable, renamed: "isAuthenticated")
    public var authenticated: Bool { return isAuthenticated }

    @available(*, unavailable, renamed: "releases(in:page:perPage:)")
    public func releasesInRepository(_ repository: Repository, page: UInt = 1, perPage: UInt = 30) -> SignalProducer<(Response, [Release]), Error> { fatalError() }

    @available(*, unavailable, renamed: "release(forTag:in:)")
    public func releaseForTag(_ tag: String, inRepository repository: Repository) -> SignalProducer<(Response, Release), Error> { fatalError() }

    @available(*, unavailable, renamed: "download(asset:)")
    public func downloadAsset(_ asset: Release.Asset) -> SignalProducer<URL, Error> { fatalError() }

    @available(*, unavailable, renamed: "user(login:)")
    public func userWithLogin(_ login: String) -> SignalProducer<(Response, UserInfo), Error> { fatalError() }

    @available(*, unavailable, renamed: "assignedIssues(page:perPage:)")
    public func assignedIssues(_ page: UInt = 1, perPage: UInt = 30) -> SignalProducer<(Response, [Issue]), Error> { fatalError() }

    @available(*, unavailable, renamed: "issues(in:page:perPage:)")
    public func issuesInRepository(_ repository: Repository, page: UInt = 1, perPage: UInt = 30) -> SignalProducer<(Response, [Issue]), Error> { fatalError() }

    @available(*, unavailable, renamed: "comments(onIssue:in:page:perPage:)")
    public func commentsOnIssue(_ issue: Int, repository: Repository, page: UInt = 1, perPage: UInt = 30) -> SignalProducer<(Response, [Comment]), Error> { fatalError() }

    @available(*, unavailable, renamed: "repositories(page:perPage:)")
    public func repositories(_ page: UInt = 1, perPage: UInt = 30) -> SignalProducer<(Response, [RepositoryInfo]), Error> { fatalError() }

    @available(*, unavailable, renamed: "repositories(forUser:page:perPage:)")
    public func repositoriesForUser(_ user: String, page: UInt = 1, perPage: UInt = 30) -> SignalProducer<(Response, [RepositoryInfo]), Error> { fatalError() }

    @available(*, unavailable, renamed: "repositories(forOrganization:page:perPage:)")
    public func repositoriesForOrganization(_ organization: String, page: UInt = 1, perPage: UInt = 30) -> SignalProducer<(Response, [RepositoryInfo]), Error> { fatalError() }

    @available(*, unavailable, renamed: "publicRepositories(page:perPage:)")
    public func publicRepositories(_ page: UInt = 1, perPage: UInt = 30) -> SignalProducer<(Response, [RepositoryInfo]), Error> { fatalError() }
}
