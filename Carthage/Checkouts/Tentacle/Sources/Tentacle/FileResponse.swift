//
//  FileResponse.swift
//  Tentacle
//
//  Created by Romain Pouclet on 2016-12-22.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

public struct FileResponse {
    /// Created file
    public let content: Content
    /// Commit associated with the file that was created
    public let commit: Commit
}

extension FileResponse: ResourceType {
    static public func decode(_ j: JSON) -> Decoded<FileResponse> {
        return curry(FileResponse.init)
            <^> j <| "content"
            <*> j <| "commit"
    }

    public var hashValue: Int {
        return content.hashValue ^ commit.hashValue
    }

    public static func ==(lhs: FileResponse, rhs: FileResponse) -> Bool {
        return true
    }
}
