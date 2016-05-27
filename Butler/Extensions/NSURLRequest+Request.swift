//
//  NSURLRequest+Request.swift
//  Butler
//
//  Created by Max Kramer on 23/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation

extension NSURLRequest {
    class func requestFrom(request: Request) -> NSMutableURLRequest? {
        guard let url = NSURL(string: request.url)?.urlByAddingSchemeIfNeeded() else {
            return nil
        }
        
        let req = NSMutableURLRequest(URL: url)
        
        let nonemptyHeaderFields = request.headers.filter {
            guard let key = $0.key, value = $0.value else {
                return false
            }
            
            return key.characters.count > 0 && value.characters.count > 0
        }
        
        nonemptyHeaderFields.forEach {
            req.addValue($0.value!, forHTTPHeaderField: $0.key!)
        }
        
        if let auth = request.authorization {
            if let authorizationHeaderVal = auth.authorizationString {
                req.addValue(authorizationHeaderVal, forHTTPHeaderField: "Authorization")
            }
        }
        
        var requestBody: NSData?
        if request.bodyFormat == BodyFormat.Plain {
            requestBody = request.parameters.bodyString()?.dataUsingEncoding(NSUTF8StringEncoding)
        } else if request.bodyFormat == BodyFormat.JSON {
            requestBody = request.parameters.bodyJSON()
        }
        
        if let requestBody = requestBody where requestBody.length > 0 {
            if request.requestMethod != .GET {
                req.addValue(String(requestBody.length), forHTTPHeaderField: "Content-Length")
                req.addValue(request.bodyFormat == BodyFormat.Plain ? "text/plain; charset=UTF-8" : "application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
                req.HTTPBody = requestBody
            } else if let params = request.parameters.bodyString() {
                let newURL = url.absoluteString + params
                req.URL = NSURL(string: newURL)
            }
        }
        req.HTTPMethod = request.requestMethod.rawValue
        
        return req
    }
}
