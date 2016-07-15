//
//  GlobalURLSession.swift
//  Butler
//
//  Created by Max Kramer on 25/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation

class GlobalURLSession {
    private static let sharedSession = GlobalURLSession()
    
    lazy var urlSession: NSURLSession = {
        return NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    }()
    
    class var urlSession: NSURLSession {
        return sharedSession.urlSession
    }
    
    deinit {
        urlSession.invalidateAndCancel()
    }
}