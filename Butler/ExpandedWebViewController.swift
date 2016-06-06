//
//  ExpandedWebViewController.swift
//  Butler
//
//  Created by Max Kramer on 06/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit
import WebKit

protocol ExpandedWebViewControllerDelegate {
    func expandedWebViewController(needsDismiss expandedWebViewController: ExpandedWebViewController)
}

class ExpandedWebViewController: UIViewController, WKNavigationDelegate {
    let response: Response
    let templateType: SyntaxHighlighter.TemplateType
    let webView: WKWebView = WKWebView()
    
    var delegate: ExpandedWebViewControllerDelegate?
    
    init(response: Response, templateType: SyntaxHighlighter.TemplateType) {
        self.response = response
        self.templateType = templateType
        super.init(nibName: nil, bundle: nil)
        webView.navigationDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(needsDismiss))
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(webView)
        
        NSLayoutConstraint.activateConstraints([
            webView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            webView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            webView.widthAnchor.constraintEqualToAnchor(view.widthAnchor),
            webView.heightAnchor.constraintEqualToAnchor(view.heightAnchor)
            ])
        
        loadResponse()
        
        super.viewDidLoad()
    }
    
    func needsDismiss() {
        guard let delegate = delegate else {
            return
        }
        
        delegate.expandedWebViewController(needsDismiss: self)
    }
    
    private func loadResponse() {
        webView.display(response, type: templateType)
    }
    
    // MARK: WKNavigationDelegate
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewWebContentProcessDidTerminate(webView: WKWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        webView.stopLoading()
        super.viewWillDisappear(animated)
    }
}