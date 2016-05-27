//
//  Authorization.swift
//  Butler
//
//  Created by Max Kramer on 26/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation
import RealmSwift

enum AuthorizationMethod: String {
    case Basic
}

class Authorization: Object {
    dynamic var rawAuthorizationMethod = AuthorizationMethod.Basic.rawValue
    dynamic var username: String? = nil
    dynamic var password: String? = nil
    
    var authorizationMethod: AuthorizationMethod {
        return AuthorizationMethod(rawValue: rawAuthorizationMethod)!
    }
    
    var authorizationString: String? {
        guard let username = username, password = password where username.characters.count > 0 && authorizationMethod == .Basic else {
            return nil
        }
        
        let authorization = "\(username):\(password)"
        
        if let encodedAuth = authorization.dataUsingEncoding(NSASCIIStringEncoding)?.base64EncodedStringWithOptions([]) {
            return "Basic \(encodedAuth)"
        }
        return nil
    }
}