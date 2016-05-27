//
//  Request.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation
import RealmSwift

class Request: Object {
    dynamic var url: String = ""
    
    let headers = List<Header>()
    let parameters = List<Parameter>()
    
    dynamic var authorization: Authorization?
    
    dynamic var rawRequestMethod: String = RequestMethod.GET.rawValue
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
