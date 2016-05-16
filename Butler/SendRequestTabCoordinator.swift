//
//  SendRequestTabCoordinator.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation
import UIKit

class SendRequestTabCoordinator: TabCoordinator {
    lazy var rootViewController: UIViewController = {
        let rvc = SendRequestViewController()
        rvc.tabBarItem = self.tabBarItem
        return rvc
    }()
    
    lazy var tabBarItem: UITabBarItem = {
        let tabBarItem = UITabBarItem(title: nil, image: R.image.sendRequestTbi(), selectedImage: R.image.sendRequestTbiSelected())
        return tabBarItem
    }()
    
    func start() {}
}