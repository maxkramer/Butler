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
    var sliderTitleLabel: UILabel!
    
    let response: Response
    var tableViewDatasource: ResponseTableViewDatasource!
    
    // MARK: Custom Initialisers
    
    init(_ response: Response) {
        self.response = response
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = R.string.localizable.responseTitle()
        let subtitle = "\(R.string.localizable.responseStatuscode()): \(response.httpResponse?.statusCode ?? 0) (\(response.readableTimeTaken()))"
        
        navigationItem.setTitle(title, subtitle: subtitle)
        
        edgesForExtendedLayout = .None
        
        // Inherent order
        let tableViewConstraints = configureTableView()
        let sliderTitleConstraints = configureSliderTitleLabel()
        let sliderConstraints = configureSlider()
        let webViewConstraints = configureWebView()
        
        let backgroundImageTuple = configureBackgroundImageView()
        
        view.addSubview(backgroundImageTuple.backgroundImageView)
        view.addSubview(webView)
        view.addSubview(tableView)
        view.addSubview(sliderTitleLabel)
        view.addSubview(slider)
        
        NSLayoutConstraint.activateConstraints(tableViewConstraints)
        NSLayoutConstraint.activateConstraints(sliderTitleConstraints)
        NSLayoutConstraint.activateConstraints(sliderConstraints)
        NSLayoutConstraint.activateConstraints(webViewConstraints)
        NSLayoutConstraint.activateConstraints(backgroundImageTuple.constraints)
        
        showRaw()
    }
    
    // MARK: UI Configuration
    
    func configureWebView() -> [NSLayoutConstraint] {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            webView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            webView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            webView.topAnchor.constraintEqualToAnchor(slider.bottomAnchor, constant: 10),
            webView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
        ]
        return constraints
    }
    
    func configureTableView() -> [NSLayoutConstraint] {
        tableView = UITableView(frame: CGRect.zero, style: .Grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clearColor()
        
        tableViewDatasource = ResponseTableViewDatasource(response: response, tableView: tableView)
        tableView.delegate = tableViewDatasource
        tableView.dataSource = tableViewDatasource
        
        let constraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.heightAnchor.constraintEqualToAnchor(view.heightAnchor, multiplier: 0.30)
        ]
        return constraints
    }
    
    func configureSliderTitleLabel() -> [NSLayoutConstraint] {
        sliderTitleLabel = UILabel()
        sliderTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let title = R.string.localizable.responseTitle()
        sliderTitleLabel.text = title.capitalizedString
        
        sliderTitleLabel.font = R.font.gothamHTFBook(size: 15)
        sliderTitleLabel.textColor = R.color.butlerColors.lightText()
        
        let constraints: [NSLayoutConstraint] = [
            sliderTitleLabel.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 10),
            sliderTitleLabel.topAnchor.constraintEqualToAnchor(tableView.bottomAnchor, constant: 10),
            ]
        return constraints
    }
    
    func configureSlider() -> [NSLayoutConstraint] {
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
        
        let constraints: [NSLayoutConstraint] = [
            slider.topAnchor.constraintEqualToAnchor(sliderTitleLabel.bottomAnchor, constant: 10),
            slider.leadingAnchor.constraintEqualToAnchor(sliderTitleLabel.leadingAnchor),
            slider.widthAnchor.constraintEqualToConstant(200),
            slider.heightAnchor.constraintEqualToConstant(40)
        ]
        return constraints
    }
    
    func configureBackgroundImageView() -> (backgroundImageView: UIView, constraints: [NSLayoutConstraint]) {
        let backgroundImageView = UIImageView(image: R.image.sendRequestBackground())
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            backgroundImageView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            backgroundImageView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor)
        ]
        
        return (backgroundImageView, constraints)
    }
    
    // MARK: Activity Indicator Management
    
    var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    func showWebViewLoadingIndicator() {
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
    
    func hideWebViewLoadingIndicator() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
    
    // MARK: WKWebViewNavigationDelegate
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        if slider.selectedIndex > 0 {
            hideWebViewLoadingIndicator()
        }
        Cerberus.info("finished loading web view for \(slider.items[slider.selectedIndex])")
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if slider.selectedIndex > 0 {
            showWebViewLoadingIndicator()
        }
        Cerberus.info("started loading web view for \(slider.items[slider.selectedIndex])")
    }
    
    func stopLoadingWebViewIfNeeded() {
        if webView.loading {
            webView.stopLoading()
            
            if let _ = activityIndicatorView.superview {
                hideWebViewLoadingIndicator()
            }
        }
    }
    
    // MARK: Data Decoding
    
    func decodeData(data: NSData) -> String? {
        if let utf8Representation = String(data: data, encoding: NSUTF8StringEncoding) {
            return utf8Representation
        }
        return String(data: data, encoding: NSASCIIStringEncoding)
    }
    
    func loadHTMLString(html: String, baseURL: NSURL?) {
        stopLoadingWebViewIfNeeded()
        webView.loadHTMLString(html, baseURL: baseURL)
    }
    
    // MARK: Slider Actions
    
    func showPreview() {
        guard let url = response.httpResponse?.URL else {
            return
        }
        
        stopLoadingWebViewIfNeeded()
        
        if let data = response.data {
            webView.loadData(data, MIMEType: "text/html", characterEncodingName: "UTF-8", baseURL: url)
        } else {
            webView.loadRequest(NSURLRequest(URL: url))
        }
    }
    
    func showRaw() {
        if let data = response.data, decodedCode = decodeData(data) {
            let highlighter = SyntaxHighlighter(code: decodedCode)
            if let html = highlighter.generateRawHTML() {
                loadHTMLString(html, baseURL: nil)
            }
        }
    }
    
    func showPretty() {
        if let data = response.data, decodedCode = decodeData(data) {
            let highlighter = SyntaxHighlighter(code: decodedCode)
            if let html = highlighter.generatePrettifiedHTML() {
                let bundlePath = NSBundle.mainBundle().bundlePath
                loadHTMLString(html, baseURL: NSURL(fileURLWithPath: bundlePath))
            }
        }
    }
}