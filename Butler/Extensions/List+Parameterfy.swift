//
//  List+Parameterfy.swift
//  Butler
//
//  Created by Max Kramer on 25/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation

extension Set where Element: KeyValueObject {
    func validObjects() -> Set<Element> {
        return Set<Element>(filter {
            if $0.key.characters.count > 0 && $0.value.characters.count > 0 {
                return false
            }
            return true
            })
    }
    
    func bodyString() -> String? {
        return reduce("") { (b, header) -> String in
            let hv = header.value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            let hk = header.key.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            if let value = hv, key = hk where key.characters.count > 0 && value.characters.count > 0 {
                let appendence = "\(key)=\(value)"
                if b.characters.count == 0 {
                    return "?" + appendence
                } else {
                    return b + "&" + appendence
                }
            }
            return b
        }
    }
    
    func bodyJSON() -> NSData? {
        guard count > 0 else {
            return nil
        }
        
        var dict = [String: AnyObject]()
        forEach {
            if $0.key.characters.count > 0 && $0.value.characters.count > 0 {
                dict[$0.key] = $0.value
            }
        }
        
        let jsonData = try? NSJSONSerialization.dataWithJSONObject(dict, options: [])
        return jsonData
    }
}