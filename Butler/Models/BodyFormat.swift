//
//  BodyFormat.swift
//  Butler
//
//  Created by Max Kramer on 26/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation

enum BodyFormat: String {
    case Plain
    case JSON
    static func allFormats() -> [BodyFormat] {
        return [.Plain, .JSON]
    }
}
