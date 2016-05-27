//
//  Response.swift
//  Butler
//
//  Created by Max Kramer on 26/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation

struct Response {
    let request: Request
    let httpResponse: NSHTTPURLResponse?
    let data: NSData?
    let error: ErrorType?
    let date = NSDate()
    
    init(request: Request, httpResponse: NSHTTPURLResponse?, data: NSData?, error: ErrorType?) {
        self.request = request
        self.httpResponse = httpResponse
        self.data = data
        self.error = error
    }
    
    func cookies() -> [NSHTTPCookie]? {
        guard let headers = httpResponse?.allHeaderFields as? [String: String] else {
            return nil
        }
        return NSHTTPCookie.cookiesWithResponseHeaderFields(headers, forURL: NSURL(string: "")!)
    }
}