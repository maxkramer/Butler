//
//  ResponseCoordinator.swift
//  Butler
//
//  Created by Max Kramer on 06/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

class ResponseCoordinator: NSObject, ResponseViewControllerDelegate, ResponseWebViewControllerDelegate {
    let parentViewController: UIViewController
    let response: Response
    var hidesBottomBarWhenPushed: Bool = false
    
    init(parentViewController: UIViewController, response: Response, hidesBottomBarWhenPushed: Bool = false) {
        self.parentViewController = parentViewController
        self.response = response
        self.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed
    }
    
    func start() {
        let responseViewController = ResponseViewController(response)
        responseViewController.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed
        responseViewController.delegate = self
        
        if let navController = parentViewController as? UINavigationController {
            navController.pushViewController(responseViewController, animated: true)
        } else if let tabController = parentViewController as? UITabBarController, selectedViewController = tabController.selectedViewController {
            if let navController = selectedViewController as? UINavigationController {
                navController.pushViewController(responseViewController, animated: true)
            } else {
                selectedViewController.presentViewController(responseViewController, animated: true, completion: nil)
            }
        } else {
            parentViewController.presentViewController(responseViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: ResponseViewControllerDelegate
    
    func responseViewController(responseViewController: ResponseViewController, needsShowExpanded type: SyntaxHighlighter.TemplateType) {
        let responseWebViewController = ResponseWebViewController(response: responseViewController.response, templateType: type)
        responseWebViewController.navigationItem.title = responseViewController.response.request.url
        responseWebViewController.delegate = self
        
        let navController = UINavigationController(rootViewController: responseWebViewController)
        responseViewController.presentViewController(navController, animated: true, completion: nil)
    }
    
    // MARK: ResponseWebViewControllerDelegate
    
    func responseWebViewController(needsDismiss responseWebViewController: ResponseWebViewController) {
        responseWebViewController.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}