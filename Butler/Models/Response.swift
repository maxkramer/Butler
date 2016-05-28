//
//  Response.swift
//  Butler
//
//  Created by Max Kramer on 26/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation

extension Double {
    func roundToPlaces(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}
struct Response {
    let request: Request
    let httpResponse: NSHTTPURLResponse?
    let data: NSData?
    let error: ErrorType?
    let date = NSDate()
    let timeTaken: Double
    
    init(request: Request, httpResponse: NSHTTPURLResponse?, data: NSData?, timeTaken: Double, error: ErrorType?) {
        self.request = request
        self.httpResponse = httpResponse
        self.data = data
        self.error = error
        self.timeTaken = timeTaken
    }
    
    func cookies() -> [NSHTTPCookie]? {
        guard let headers = httpResponse?.allHeaderFields as? [String: String] else {
            return nil
        }
        return NSHTTPCookie.cookiesWithResponseHeaderFields(headers, forURL: NSURL(string: "")!)
    }
    
    func readableTimeTaken() -> String {
        if timeTaken > 100 {
            return "\((timeTaken / 60).roundToPlaces(2))min"
        } else if timeTaken < 1e-6 {
            return "\((timeTaken * 1e9).roundToPlaces(2))ns"
        } else if timeTaken < 1e-3 {
            return "\((timeTaken * 1e6).roundToPlaces(2))µs"
        } else if timeTaken < 1 {
            return "\((timeTaken * 1000).roundToPlaces(2))ms"
        }
        return "\(timeTaken.roundToPlaces(2))s"
    }
}