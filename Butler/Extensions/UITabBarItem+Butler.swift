//
//  UITabBarItem+Butler.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit
import Rswift

extension UITabBarItem {
    convenience init(image: ImageResource, selectedImage: ImageResource, topInset: CGFloat = 0) {
        self.init()
        self.image = UIImage(resource: image)?.imageWithRenderingMode(.AlwaysOriginal)
        self.selectedImage = UIImage(resource: selectedImage)?.imageWithRenderingMode(.AlwaysOriginal)
        self.imageInsets = UIEdgeInsets(top: topInset, left: 0, bottom: -topInset, right: 0)
    }
    
}
