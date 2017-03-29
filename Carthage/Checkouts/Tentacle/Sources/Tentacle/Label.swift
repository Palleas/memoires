//
//  Label.swift
//  Tentacle
//
//  Created by Romain Pouclet on 2016-05-23.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

public struct Label: CustomStringConvertible {
    public let name: String
    public let color: Color

    public var description: String {
        return name
    }
}

extension Label: Hashable {
    public static func ==(lhs: Label, rhs: Label) -> Bool {
        return lhs.name == rhs.name
    }

    public var hashValue: Int {
        return name.hashValue
    }
}

extension Label: ResourceType {
    public static func decode(_ json: JSON) -> Decoded<Label> {
        let f = curry(Label.init)
        return f
            <^> json <| "name"
            <*> (json <| "color" >>- toColor)
    }
}
