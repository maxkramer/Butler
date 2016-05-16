//
//  TabCoordinator.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation
import UIKit

protocol TabCoordinator {
    func start()
    func end()
    
    var rootViewController: UIViewController { get set }
    var tabBarItem: UITabBarItem { get set }
}

extension TabCoordinator {
    func end() {}
}