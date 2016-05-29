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
        if let error = response.error as? NSError {
            Cerberus.error(error)
            
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: { [unowned self] _ in
                self.rootViewController.dismissViewControllerAnimated(true, completion: nil)
                }))
            
            rootViewController.presentViewController(alertController, animated: true, completion: nil)
        } else {
            delegate?.sendRequestTabCoordinator(self, didReceiveResponse: response)
        }
    }
}