//
//  RequestMethod.swift
//  Butler
//
//  Created by Max Kramer on 26/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation

enum RequestMethod: String {
    case GET
    case PUT
    case POST
    case DELETE
    
    static func allMethods() -> [RequestMethod] {
        return [.GET, .PUT, .POST, .DELETE]
    }
}