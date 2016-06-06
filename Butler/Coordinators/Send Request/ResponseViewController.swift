//
//  ResponseViewController.swift
//  Butler
//
//  Created by Max Kramer on 27/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit
import WebKit

protocol ResponseViewControllerDelegate {
    func responseViewController(responseViewController: ResponseViewController, needsShowExpanded type: SyntaxHighlighter.TemplateType)
}

final class ResponseViewController: UIViewController, WKNavigationDelegate {
    var tableView: UITableView!
    var webView: WKWebView!
    var slider: MultipleButtonSlider!
    var sliderTitleLabel: UILabel!
    
    var delegate: ResponseViewControllerDelegate?
    
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
        let expandButtonTuple = configureExpandButton()
        
        view.addSubview(backgroundImageTuple.backgroundImageView)
        view.addSubview(webView)
        view.addSubview(tableView)
        view.addSubview(sliderTitleLabel)
        view.addSubview(slider)
        view.addSubview(expandButtonTuple.expandButton)
        
        NSLayoutConstraint.activateConstraints(tableViewConstraints)
        NSLayoutConstraint.activateConstraints(sliderTitleConstraints)
        NSLayoutConstraint.activateConstraints(sliderConstraints)
        NSLayoutConstraint.activateConstraints(webViewConstraints)
        NSLayoutConstraint.activateConstraints(backgroundImageTuple.constraints)
        NSLayoutConstraint.activateConstraints(expandButtonTuple.constraints)
        
        webView.display(response, type: .Raw)
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
            self.stopLoadingWebViewIfNeeded()
            if index == 0 {
                self.webView.display(self.response, type: SyntaxHighlighter.TemplateType.Raw)
            } else if index == 1 {
                self.webView.display(self.response, type: SyntaxHighlighter.TemplateType.Pretty)
            } else if index == 2 {
                self.webView.display(self.response, type: SyntaxHighlighter.TemplateType.Preview)
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
    
    func configureExpandButton() -> (expandButton: UIButton, constraints: [NSLayoutConstraint]) {
        let iconImage = R.image.ic_open_in_new()!
        let button = UIButton(type: .Custom)
        button.setImage(iconImage, forState: .Normal)
        button.addTarget(self, action: #selector(showExpandedWebView), forControlEvents: .TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            button.trailingAnchor.constraintEqualToAnchor(webView.trailingAnchor, constant: -10),
            button.topAnchor.constraintEqualToAnchor(webView.topAnchor, constant: 10)
        ]
        return (button, constraints)
    }
    
    func showExpandedWebView() {
        guard let delegate = delegate else {
            return
        }
        
        var templateType = SyntaxHighlighter.TemplateType.Preview
        
        if slider.selectedIndex == 0 {
            templateType = .Raw
        } else if slider.selectedIndex == 1 {
            templateType = .Pretty
        }
        
        delegate.responseViewController(self, needsShowExpanded: templateType)
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
}