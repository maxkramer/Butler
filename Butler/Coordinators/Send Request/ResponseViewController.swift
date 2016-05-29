//
//  ResponseViewController.swift
//  Butler
//
//  Created by Max Kramer on 27/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit
import WebKit

final class ResponseViewController: UIViewController, WKNavigationDelegate {
    var tableView: UITableView!
    var webView: WKWebView!
    var slider: MultipleButtonSlider!
    var sliderTitle: UILabel!
    
    let response: Response
    var tableViewDatasource: ResponseTableViewDatasource!
    
    init(_ response: Response) {
        self.response = response
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = R.string.localizable.responseTitle()
        let subtitle = "\(R.string.localizable.responseStatuscode()): \(response.httpResponse?.statusCode ?? 0) (\(response.readableTimeTaken()))"
        
        navigationItem.setTitle(title, subtitle: subtitle)
        
        tableView = UITableView(frame: CGRect.zero, style: .Grouped)
        sliderTitle = UILabel()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        
        view.backgroundColor = UIColor.whiteColor()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        sliderTitle.translatesAutoresizingMaskIntoConstraints = false
        
        edgesForExtendedLayout = .None
        
        sliderTitle.text = title.capitalizedString
        sliderTitle.font = R.font.gothamHTFBook(size: 15)
        sliderTitle.textColor = R.color.butlerColors.lightText()
        
        slider = MultipleButtonSlider.butlerSlider(["Raw", "Pretty", "Preview"], callback: { [unowned self] index in
            if index == 0 {
                self.showRaw()
            } else if index == 1 {
                self.showPretty()
            } else if index == 2 {
                self.showPreview()
            }
            })
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        let backgroundImageView = UIImageView(image: R.image.sendRequestBackground())
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        view.addSubview(webView)
        view.addSubview(tableView)
        view.addSubview(sliderTitle)
        view.addSubview(slider)
        
        tableViewDatasource = ResponseTableViewDatasource(response: response, tableView: tableView)
        tableView.delegate = tableViewDatasource
        tableView.dataSource = tableViewDatasource
        tableView.backgroundColor = UIColor.clearColor()
        
        NSLayoutConstraint.activateConstraints([
            backgroundImageView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            backgroundImageView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.heightAnchor.constraintEqualToAnchor(view.heightAnchor, multiplier: 0.30),
            sliderTitle.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 10),
            sliderTitle.topAnchor.constraintEqualToAnchor(tableView.bottomAnchor, constant: 10),
            slider.topAnchor.constraintEqualToAnchor(sliderTitle.bottomAnchor, constant: 10),
            slider.leadingAnchor.constraintEqualToAnchor(sliderTitle.leadingAnchor),
            slider.widthAnchor.constraintEqualToConstant(200),
            slider.heightAnchor.constraintEqualToConstant(40),
            webView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            webView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            webView.topAnchor.constraintEqualToAnchor(slider.bottomAnchor, constant: 10),
            webView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
            ])
        
        showRaw()
    }
    
    var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        if slider.selectedIndex == 1 {
            activityIndicatorView.stopAnimating()
            activityIndicatorView.removeFromSuperview()
            Cerberus.trace("finished loading \(slider.items[slider.selectedIndex])")
        }
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if slider.selectedIndex == 1 {
            
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicatorView.backgroundColor = R.color.butlerColors.lightText()
            activityIndicatorView.layer.cornerRadius = 8
            activityIndicatorView.layer.masksToBounds = true
            
            webView.addSubview(activityIndicatorView)
            
            NSLayoutConstraint.activateConstraints([
                activityIndicatorView.centerXAnchor.constraintEqualToAnchor(webView.centerXAnchor),
                activityIndicatorView.centerYAnchor.constraintEqualToAnchor(webView.centerYAnchor),
                activityIndicatorView.widthAnchor.constraintEqualToConstant(100),
                activityIndicatorView.heightAnchor.constraintEqualToAnchor(activityIndicatorView.widthAnchor)
                ])
            
            activityIndicatorView.startAnimating()
        }
    }
    
    func decodeData(data: NSData) -> String? {
        if let utf8Representation = String(data: data, encoding: NSUTF8StringEncoding) {
            return utf8Representation
        }
        return String(data: data, encoding: NSASCIIStringEncoding)
    }
    
    func showPreview() {
        if let url = response.httpResponse?.URL {
            if let data = response.data {
                webView.loadData(data, MIMEType: "text/html", characterEncodingName: "UTF-8", baseURL: url)
            }
        } else {
            webView.loadHTMLString("<h1>Unable to decode the data</h1>", baseURL: nil)
        }
    }
    
    func showRaw() {
        if let data = response.data, decodedCode = decodeData(data) {
            let highlighter = SyntaxHighlighter(code: decodedCode)
            if let html = highlighter.generateRawHTML() {
                webView.loadHTMLString(html, baseURL: nil)
            }
        }
    }
    
    func showPretty() {
        if let data = response.data, decodedCode = decodeData(data) {
            let highlighter = SyntaxHighlighter(code: decodedCode)
            if let html = highlighter.generatePrettifiedHTML() {
                
                
                //                NSString *path = [[NSBundle mainBundle] bundlePath];
                //                NSURL *baseURL = [NSURL fileURLWithPath:path];
                
                let bundlePath = NSBundle.mainBundle().bundlePath
                
                webView.loadHTMLString(html, baseURL: NSURL(fileURLWithPath: bundlePath))
            }
        }
    }
}