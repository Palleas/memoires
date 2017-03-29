//
//  Decodable.swift
//  Tentacle
//
//  Created by Matt Diephouse on 3/3/16.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Argo
import Foundation

extension URL: Decodable {
    public static func decode(_ json: JSON) -> Decoded<URL> {
        return String.decode(json).flatMap { URLString in
            return .fromOptional(self.init(string: URLString))
        }
    }
}
