//
//  Server.swift
//  Tentacle
//
//  Created by Matt Diephouse on 3/3/16.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Foundation


/// A GitHub.com or GitHub Enterprise server.
public enum Server: CustomStringConvertible {
    /// The GitHub.com server.
    case dotCom
    
    /// A GitHub Enterprise server.
    case enterprise(url: URL)
    
    /// The URL of the server.
    public var url: URL {
        switch self {
        case .dotCom:
            return URL(string: "https://github.com")!
        
        case let .enterprise(url):
            return url
        }
    }
    
    internal var endpoint: String {
        switch self {
        case .dotCom:
            return "https://api.github.com"
            
        case let .enterprise(url):
            return "\(url.scheme!)://\(url.host!)/api/v3"
        }
    }
    
    public var description: String {
        return "\(url)"
    }
}

extension Server: Hashable {
    public static func ==(lhs: Server, rhs: Server) -> Bool {
        switch (lhs, rhs) {
        case (.dotCom, .dotCom):
            return true

        case (.enterprise, .enterprise):
            return lhs.endpoint.caseInsensitiveCompare(rhs.endpoint) == .orderedSame

        default:
            return false
        }
    }

    public var hashValue: Int {
        return endpoint.lowercased().hashValue
    }
}
