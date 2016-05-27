//
//  SendRequestTabCoordinator.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

class SendRequestTabCoordinator: TabCoordinator, SendRequestViewControllerDelegate {
    lazy var rootViewController: UIViewController = {
        let rvcNib = R.nib.sendRequestViewController
        
        let rvc = SendRequestViewController(nibName: rvcNib.name, bundle: rvcNib.bundle)
        rvc.tabBarItem = self.tabBarItem
        rvc.navigationItem.title = R.string.localizable.sendrequestTitle()
        rvc.delegate = self
        return rvc
    }()
    
    var tabBarItem = UITabBarItem(image: R.image.sendRequestTbi, selectedImage: R.image.sendRequestTbiSelected, topInset: 5)
    
    func start() {}
    
    // MARK: SendRequestViewControllerDelegate
    
    func sendRequestViewController(sendRequestViewController: SendRequestViewController, didSendRequestSuccessfully response: Response) {
        Cerberus.info("Request sent successfully. Received response: \(response)")
    }
}