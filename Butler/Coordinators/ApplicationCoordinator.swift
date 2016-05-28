//
//  ApplicationCoordinator.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

class ApplicationCoordinator: SendRequestTabCoordinatorDelegate {
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    lazy var tabBarCoordinators: [TabCoordinator] = {
        let sendRequestCoordinator = SendRequestTabCoordinator()
        sendRequestCoordinator.delegate = self
        
        return [sendRequestCoordinator, HistoryTabCoordinator(), FavouriteTabCoordinator()]
    }()
    
    let tabBarController = UITabBarController()
    
    func start() {
        tabBarController.setViewControllers(tabBarCoordinators.map { UINavigationController(rootViewController:$0.rootViewController) }, animated: false)
        window.rootViewController = tabBarController
    }
    
    func sendRequestTabCoordinator(sendRequestTabCoordinator: SendRequestTabCoordinator, didReceiveResponse response: Response) {
        let responseViewController = ResponseViewController(response)
        if let navigationController = tabBarController.viewControllers?.first as? UINavigationController {
            responseViewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(responseViewController, animated: true)
        }
    }
}
