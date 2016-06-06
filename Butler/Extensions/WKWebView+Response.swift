//
//  WKWebView+Response.swift
//  Butler
//
//  Created by Max Kramer on 29/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {
    
    private func decodeData(data: NSData) -> String? {
        if let utf8Representation = String(data: data, encoding: NSUTF8StringEncoding) {
            return utf8Representation
        }
        return String(data: data, encoding: NSASCIIStringEncoding)
    }
    
    private func showPreview(response: Response) {
        guard let url = response.httpResponse?.URL else {
            return
        }
        
        if let data = response.data {
            loadData(data, MIMEType: "text/html", characterEncodingName: "UTF-8", baseURL: url)
        } else {
            loadRequest(NSURLRequest(URL: url))
        }
    }
    
    private func showRaw(response: Response) {
        if let data = response.data, decodedCode = decodeData(data) {
            let highlighter = SyntaxHighlighter(code: decodedCode)
            if let html = highlighter.generateRawHTML() {
                loadHTMLString(html, baseURL: nil)
            } else {
                Cerberus.error("Unable to generate raw html")
            }
        } else {
            Cerberus.error("Unable to decode the raw data")
        }
    }
    
    private func showPretty(response: Response) {
        if let data = response.data, decodedCode = decodeData(data) {
            let highlighter = SyntaxHighlighter(code: decodedCode)
            if let html = highlighter.generatePrettifiedHTML() {
                let bundlePath = NSBundle.mainBundle().bundlePath
                loadHTMLString(html, baseURL: NSURL(fileURLWithPath: bundlePath))
            }
        }
    }
    
    func display(response: Response, type: SyntaxHighlighter.TemplateType) {
        if type == SyntaxHighlighter.TemplateType.Pretty {
            showPretty(response)
        } else if type == .Raw {
            showRaw(response)
        } else {
            showPreview(response)
        }
    }
}