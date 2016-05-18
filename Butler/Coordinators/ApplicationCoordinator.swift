//
//  ApplicationCoordinator.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

class ApplicationCoordinator {
    
    var applicationWindow: UIWindow
    
    init(window: UIWindow) {
        self.applicationWindow = window
    }
    
    lazy var tabBarCoordinators: [TabCoordinator] = {
        return [SendRequestTabCoordinator(), HistoryTabCoordinator(), FavouriteTabCoordinator()]
    }()
    
    let tabBarController = UITabBarController()
    
    func start() {
        tabBarController.setViewControllers(tabBarCoordinators.map { UINavigationController(rootViewController:$0.rootViewController) }, animated: false)
        applicationWindow.rootViewController = tabBarController
    }
}
