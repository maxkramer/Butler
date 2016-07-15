//
//  HistoryTabCoordinator.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

class HistoryTabCoordinator: TabCoordinator, HistoryViewControllerDelegate {
    lazy var rootViewController: UIViewController = {
        let rvc = HistoryViewController()
        rvc.tabBarItem = self.tabBarItem
        rvc.navigationItem.title = R.string.localizable.historyTitle()
        rvc.delegate = self
        return rvc
    }()
    
    var tabBarItem = UITabBarItem(image: R.image.historyTbi, selectedImage: R.image.historyTbiSelected, topInset: 5)
    
    func start() {}
    
    func historyViewController(historyViewController: HistoryViewController, needsDisplayRequest request: Request) {
        let rc = SendRequestTabCoordinator(request)
        
    }
}
