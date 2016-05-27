//
//  FavouriteTabCoordinator.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

class FavouriteTabCoordinator: TabCoordinator {    
    lazy var rootViewController: UIViewController = {
        let rvc = FavouriteViewController()
        rvc.tabBarItem = self.tabBarItem
        rvc.navigationItem.title = R.string.localizable.favouriteTitle()
        return rvc
    }()
    
    var tabBarItem = UITabBarItem(image: R.image.favouriteTbi, selectedImage: R.image.favouriteTbiSelected, topInset: 7)
    
    func start() {}
}
