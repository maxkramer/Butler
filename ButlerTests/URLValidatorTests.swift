//
//  URLValidatorTests.swift
//  Butler
//
//  Created by Max Kramer on 22/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import XCTest

class URLValidatorTests: XCTestCase {
    
    var validURLs: [String]!
    var invalidURLs: [String]!
    
    override func setUp() {
        guard let filePath = NSBundle(forClass: URLValidatorTests.self).pathForResource("urls", ofType: "json") else {
            XCTFail("Unable to find the URL json file")
            fatalError()
        }
        
        guard let jsonData = NSData(contentsOfFile: filePath), decodedJSON = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? [[String: AnyObject]] else {
            XCTFail("Unable to decode the URL json file")
            fatalError()
        }
        
        validURLs = [String]()
        invalidURLs = [String]()
        
        decodedJSON!.forEach {
            if $0["valid"] as! Bool == true {
                validURLs.append($0["url"] as! String)
            } else {
                invalidURLs.append($0["url"] as! String)
            }
        }
        
        XCTAssertGreaterThan(validURLs.count, 0)
        XCTAssertGreaterThan(invalidURLs.count, 0)
        
        super.setUp()
    }
    
    func urlIsValid(url: String) -> Bool {
        guard url.characters.count > 0 else { // a.c
            return false
        }
        
        // first check to see if the url can be encoded correctly to a valid url
        
        let attemptedEncode = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        guard let encodedString = attemptedEncode else {
            XCTFail("encoding failed")
            return false
        }
        
        // check to see that a valid NSURL can be created from the encoded string
        
        guard let actualUrl = NSURL(string: encodedString) else {
            return false
        }
        
        // scheme can or cannot exist and if does exist must be http:// or https://
        
        let scheme = actualUrl.scheme
        if scheme.characters.count > 0 {
            let validScheme = (scheme == "http" || scheme == "https")
            guard validScheme == true else {
                return false
            }
        }
        
        // hostname must exist as url or ipv4/v6 address
        
        guard let _ = actualUrl.host else {
            XCTFail("Invalid host \(url)")
            return false
        }
        
        // include a tld
        // port can exist
        // username:password can exist
        // query can exist
        // fragment can exist
        
        return true
    }
    
    func testValidURLs() {
        validURLs.forEach {
            XCTAssertTrue(urlIsValid($0), $0)
        }
    }
    
    func testInvalidURLs() {
        let url = NSURL(string: "foo.com")
        XCTAssertNotNil(url?.host)
        
        invalidURLs.forEach {
            XCTAssertFalse(urlIsValid($0), $0)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
