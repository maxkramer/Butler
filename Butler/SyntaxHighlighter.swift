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
    
    enum TemplateType: String {
        case Raw =  "raw"
        case Pretty = "syntaxhighlighter"
        case Preview = ""
    }
    
    private func generateTemplate(type: TemplateType, code: String) -> String? {
        var templateURL: NSURL?
        switch type {
        case .Raw:
            templateURL = R.file.rawHtml()
            break
        case .Pretty:
            templateURL = R.file.syntaxhighlighterHtml()
            break
        default:
            return nil
        }
        
        guard let templateFileURL = templateURL,
            templateString = try? String(contentsOfURL: templateFileURL),
            codeRange = templateString.rangeOfString("{code}") else {
                return nil
        }
        
        let html = templateString.stringByReplacingCharactersInRange(codeRange, withString: (code as NSString).gtm_stringByEscapingForHTML())
        return html
    }
    
    func generateRawHTML() -> String? {
        return generateTemplate(.Raw, code: code)
    }
    
    private func templatedHTMLString(templateURL: NSURL) -> String? {
        return try? String(contentsOfURL: templateURL)
    }
    
    func generatePrettifiedHTML() -> String? {
        return generateTemplate(.Pretty, code: code)
    }
}
