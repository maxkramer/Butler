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

class Authorization: Object {
    dynamic var rawAuthorizationMethod = AuthorizationMethod.Basic.rawValue
    dynamic var password: String? = nil
    
    var authorizationMethod: AuthorizationMethod {
        return AuthorizationMethod(rawValue: rawAuthorizationMethod)!
    }
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
    
    dynamic var authorization: Authorization?
    
    dynamic var rawRequestMethod: Int = RequestMethod.GET.rawValue
    dynamic var rawBodyFormat: String = BodyFormat.Plain.rawValue
    
    var requestMethod: RequestMethod {
        return RequestMethod(rawValue: rawRequestMethod)!
    }
    
    var bodyFormat: BodyFormat {
        return BodyFormat(rawValue: rawBodyFormat)!
    }
    
    static func create(headers: [Header]?, parameters: [Parameter]?, authorization: Authorization?) -> Request {
        let request = Request()
        if let headers = headers {
            request.headers.appendContentsOf(headers)
        }
        if let parameters = parameters {
            request.parameters.appendContentsOf(parameters)
        }
        if let authorization = authorization {
            request.authorization = authorization
        }
        return request
    }
}
