//
//  SendRequestTabCoordinator.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

class SendRequestTabCoordinator: TabCoordinator {
    lazy var rootViewController: UIViewController = {
        let rvc = SendRequestViewController(nibName: "SendRequestViewController", bundle: NSBundle.mainBundle())
        rvc.tabBarItem = self.tabBarItem
        rvc.navigationItem.title = R.string.localizable.sendrequestTitle()
        return rvc
    }()
    
    var tabBarItem = UITabBarItem(image: R.image.sendRequestTbi, selectedImage: R.image.sendRequestTbiSelected, topInset: 5)
    
    func start() {}
}
