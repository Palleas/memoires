//
//  Content.swift
//  Tentacle
//
//  Created by Romain Pouclet on 2016-11-28.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes


/// Content
/// https://developer.github.com/v3/repos/contents/
///
/// - file: a file when queried directly in a repository
/// - directory: a directory when queried directly in a repository (may contain multiple files)
public enum Content {
    /// A file in a repository
    public struct File: CustomStringConvertible {

        /// Type of content in a repository
        ///
        /// - file: a file in a repository
        /// - directory: a directory in a repository
        /// - symlink: a symlink in a repository not targeting a file inside the same repository
        /// - submodule: a submodule in a repository
        public enum ContentType {
            /// A file a in a repository
            case file(size: Int, downloadURL: URL?)

            /// A directory in a repository
            case directory

            /// A symlink in a repository. Target and URL are optional because they are treated as regular files
            /// when they are the result of a query for a directory
            /// See https://developer.github.com/v3/repos/contents/
            case symlink(target: String?, downloadURL: URL?)

            /// A submodule in a repository. URL is optional because they are treated as regular files
            /// when they are the result of a query for a directory
            /// See https://developer.github.com/v3/repos/contents/
            case submodule(url: String?)
        }

        /// The type of content
        public let content: ContentType

        /// Name of the file
        public let name: String

        /// Path to the file in repository
        public let path: String

        /// Sha of the file
        public let sha: String

        /// URL to preview the content
        public let url: URL

        public var description: String {
            return name
        }

    }

    case file(File)
    case directory([File])
}

func decodeFile(_ j: JSON) -> Decoded<Content.File.ContentType> {
    return curry(Content.File.ContentType.file)
        <^> j <| "size"
        <*> (j <|? "download_url" >>- toOptionalURL)
}

func decodeSymlink(_ j: JSON) -> Decoded<Content.File.ContentType> {
    return curry(Content.File.ContentType.symlink)
        <^> j <|? "target"
        <*> (j <|? "download_url" >>- toOptionalURL)
}

func decodeSubmodule(_ j: JSON) -> Decoded<Content.File.ContentType> {
    return curry(Content.File.ContentType.submodule)
        <^> j <|? "submodule_git_url"
}


extension Content.File.ContentType: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Content.File.ContentType> {
        guard case let .object(payload) = json else {
            return .failure(.typeMismatch(expected: "object", actual: "\(json)"))
        }

        guard let type = payload["type"], case let .string(value) = type else {
            return .failure(.custom("Content type is invalid"))
        }

        switch value {
        case "file":
            if payload["download_url"] == .null {
                return decodeSubmodule(json)
            }
            return decodeFile(json)
        case "dir":
            return .success(Content.File.ContentType.directory)
        case "submodule":
            return decodeSubmodule(json)
        case "symlink":
            return decodeSymlink(json)
        default:
            return .failure(.custom("Content type \(value) is invalid"))
        }
    }
}

extension Content: Hashable {
    public static func ==(lhs: Content, rhs: Content) -> Bool {
        switch (lhs, rhs) {
        case let (.file(file1), .file(file2)):
            return file1 == file2
        case let (.directory(dir1), .directory(dir2)):
            return dir1 == dir2
        default:
            return false
        }
    }

    public var hashValue: Int {
        switch self {
        case .file(let file):
            return "file".hashValue ^ file.hashValue
        case .directory(let files):
            return files.reduce("directory".hashValue) { $0.hashValue ^ $1.hashValue }
        }
    }
}

extension Content.File.ContentType: Equatable {
    public static func ==(lhs: Content.File.ContentType, rhs: Content.File.ContentType) -> Bool {
        switch (lhs, rhs) {
        case let (.file(size, url), .file(size2, url2)):
            return size == size2 && url == url2
        case (.directory, .directory):
            return true
        case let (.submodule(url), .submodule(url2)):
            return url == url2
        case let (.symlink(target, url), .symlink(target2, url2)):
            return target == target2 && url == url2
        default:
            return false
        }
    }
}

extension Content: ResourceType {
    public static func decode(_ j: JSON) -> Decoded<Content> {

        switch j {
        case .array(_):
            return Array<Content.File>.decode(j).map(Content.directory)
        case .object(_):
            return Content.File.decode(j).map(Content.file)
        default:
            return .failure(.typeMismatch(expected: "Array or Object", actual: "\(j)"))
        }
    }
}

extension Content.File: Hashable {
    public static func ==(lhs: Content.File, rhs: Content.File) -> Bool {
        return lhs.name == rhs.name
            && lhs.path == rhs.path
            && lhs.sha == rhs.sha
            && lhs.content == rhs.content
    }

    public var hashValue: Int {
        return name.hashValue
    }
}

extension Content.File: ResourceType {
    public static func decode(_ j: JSON) -> Decoded<Content.File> {
        let f = curry(Content.File.init)

        return f
            <^> Content.File.ContentType.decode(j)
            <*> j <| "name"
            <*> j <| "path"
            <*> j <| "sha"
            <*> (j <| "html_url" >>- toURL)
    }
}
