//
//  List+Parameterfy.swift
//  Butler
//
//  Created by Max Kramer on 25/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation
import RealmSwift

extension List where T: Header {
    func bodyString() -> String? {
        return reduce("") { (b, header) -> String in
            let hv = header.value?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            let hk = header.key?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
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
            if let value = $0.value, key = $0.key where key.characters.count > 0 && value.characters.count > 0 {
                dict[key] = value
            }
        }
        
        let jsonData = try? NSJSONSerialization.dataWithJSONObject(dict, options: [])
        return jsonData
    }
}
