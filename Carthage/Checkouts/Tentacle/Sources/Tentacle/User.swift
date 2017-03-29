//
//  User.swift
//  Tentacle
//
//  Created by Matt Diephouse on 4/12/16.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

/// A User on GitHub.
public struct User: CustomStringConvertible {
    public enum UserType: String {
        case user = "User"
        case organization = "Organization"
    }

    /// The unique ID of the user.
    public let id: String
    
    /// The user's login/username.
    public let login: String
    
    /// The URL of the user's GitHub page.
    public let url: URL
    
    /// The URL of the user's avatar.
    public let avatarURL: URL

    /// The type of user if it's a regular one or an organization
    public let type: UserType

    public var description: String {
        return login
    }
}

extension User: Hashable {
    public static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
            && lhs.login == rhs.login
            && lhs.url == rhs.url
            && lhs.avatarURL == rhs.avatarURL
    }

    public var hashValue: Int {
        return id.hashValue
    }
}

extension User: ResourceType {
    public static func decode(_ j: JSON) -> Decoded<User> {
        return curry(self.init)
            <^> (j <| "id" >>- toString)
            <*> j <| "login"
            <*> j <| "html_url"
            <*> j <| "avatar_url"
            <*> (j <| "type" >>- toUserType)
    }
}

/// Extended information about a user on GitHub.
public struct UserInfo {
    /// The user that this information refers to.
    public let user: User
    
    /// The date that the user joined GitHub.
    public let joinedDate: Date
    
    /// The user's name if they've set one.
    public let name: String?
    
    /// The user's public email address if they've set one.
    public let email: String?
    
    /// The URL of the user's website if they've set one
    public let websiteURL: URL?
    
    /// The user's company if they've set one.
    public let company: String?
    
    public var description: String {
        return user.description
    }
    
    public init(user: User, joinedDate: Date, name: String?, email: String?, websiteURL: URL?, company: String?) {
        self.user = user
        self.joinedDate = joinedDate
        self.name = name
        self.email = email
        self.websiteURL = websiteURL
        self.company = company
    }
}

extension UserInfo: Hashable {
    public static func ==(lhs: UserInfo, rhs: UserInfo) -> Bool {
        return lhs.user == rhs.user
            && lhs.joinedDate == rhs.joinedDate
            && lhs.name == rhs.name
            && lhs.email == rhs.email
            && lhs.websiteURL == rhs.websiteURL
            && lhs.company == rhs.company
    }

    public var hashValue: Int {
        return user.hashValue
    }
}

extension UserInfo: ResourceType {
    public static func decode(_ j: JSON) -> Decoded<UserInfo> {
        return curry(self.init)
            <^> j <| []
            <*> (j <| "created_at" >>- toDate)
            <*> j <|? "name"
            <*> j <|? "email"
            <*> j <|? "blog"
            <*> j <|? "company"
    }
}
