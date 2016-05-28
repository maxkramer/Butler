//
//  SyntaxHighlighter.swift
//  Butler
//
//  Created by Max Kramer on 28/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit
import GTMNSStringHTMLAdditions

struct SyntaxHighlighter {
    let code: String
    
    init(code: String) {
        self.code = code
    }
    
    func generateRawHTML() -> String? {
        let templateURL = R.file.rawHtml()
        
        if let templateURL = templateURL, var templateString = try? String(contentsOfURL: templateURL) {
            if let codeRange = templateString.rangeOfString("{code}") {
                templateString.replaceRange(codeRange, with: (code as NSString).gtm_stringByEscapingForHTML())
                return templateString
            }
        }
        
        return nil
    }
    
    func generatePrettifiedHTML() -> String? {
        let templateURL = R.file.syntaxhighlighterHtml()
        
        if let templateURL = templateURL, var templateString = try? String(contentsOfURL: templateURL) {
            if let codeRange = templateString.rangeOfString("{code}") {
                templateString.replaceRange(codeRange, with: (code as NSString).gtm_stringByEscapingForHTML())
                return templateString
            }
        }
        return nil
    }
}
