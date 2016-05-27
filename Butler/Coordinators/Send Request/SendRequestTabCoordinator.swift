//
//  SendRequestTabCoordinator.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

protocol SendRequestTabCoordinatorDelegate {
    func sendRequestTabCoordinator(sendRequestTabCoordinator: SendRequestTabCoordinator, didReceiveResponse response: Response)
}

class SendRequestTabCoordinator: TabCoordinator, SendRequestViewControllerDelegate {
    var delegate: SendRequestTabCoordinatorDelegate?
    
    lazy var rootViewController: UIViewController = {
        let rvcNib = R.nib.sendRequestViewController
        
        let rvc = SendRequestViewController(nibName: rvcNib.name, bundle: rvcNib.bundle)
        rvc.tabBarItem = self.tabBarItem
        rvc.navigationItem.title = R.string.localizable.sendrequestTitle()
        rvc.delegate = self
        return rvc
    }()
    
    var tabBarItem = UITabBarItem(image: R.image.sendRequestTbi, selectedImage: R.image.sendRequestTbiSelected, topInset: 5)
    
    // MARK: SendRequestViewControllerDelegate
    
    func sendRequestViewController(sendRequestViewController: SendRequestViewController, didSendRequestSuccessfully response: Response) {
        Cerberus.info("Request sent successfully. Received response: \(response)")
        delegate?.sendRequestTabCoordinator(self, didReceiveResponse: response)
    }
}