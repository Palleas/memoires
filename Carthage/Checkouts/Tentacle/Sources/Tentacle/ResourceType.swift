//
//  ResourceType.swift
//  Tentacle
//
//  Created by Matt Diephouse on 3/10/16.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Argo

/// A Resource from the GitHub API.
public protocol ResourceType: Decodable, Hashable {
    static func decode(_ json: JSON) -> Decoded<Self>
}

public protocol RequestType: Encodable, Hashable {
    associatedtype Response: Decodable
}
