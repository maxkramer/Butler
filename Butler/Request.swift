//
//  Request.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation
import RealmSwift

enum RequestMethod: Int {
    case GET
    case PUT
    case POST
    case DELETE
}

enum BodyFormat: String {
    case Plain
    case JSON
}

enum AuthorizationMethod: String {
    case Basic
}

class Header: Object {
    dynamic var key: String? = nil
    dynamic var value: String? = nil
}

class Parameter: Header {}

class Request: Object {
    dynamic var url: String = ""
    
    let headers = List<Header>()
    let parameters = List<Parameter>()
    
    dynamic var rawRequestMethod: Int = RequestMethod.GET.rawValue
    dynamic var rawBodyFormat: String = BodyFormat.Plain.rawValue
    dynamic var rawAuthorizationMethod = AuthorizationMethod.Basic.rawValue
    
    dynamic var authorizationBody: String? = nil
    
    var requestMethod: RequestMethod {
        return RequestMethod(rawValue: rawRequestMethod)!
    }
    
    var bodyFormat: BodyFormat {
        return BodyFormat(rawValue: rawBodyFormat)!
    }
    
    var authorizationMethod: AuthorizationMethod {
        return AuthorizationMethod(rawValue: rawAuthorizationMethod)!
    }
}
