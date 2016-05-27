//
//  NSURL+Tidy.swift
//  Butler
//
//  Created by Max Kramer on 25/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation

extension NSURL {
    func urlByAddingSchemeIfNeeded(newScheme: String = "http") -> NSURL? {
        if scheme.characters.count == 0 {
            if newScheme.characters.count > 0 {
                return NSURL(string: "\(newScheme)://" + absoluteString)
            } else {
                return NSURL(string: "http://" + absoluteString)
            }
        }
        return self
    }
}