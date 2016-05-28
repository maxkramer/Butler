//
//  UINavigationItem+Subtitle.swift
//  Butler
//
//  Created by Max Kramer on 27/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

extension UINavigationItem {
    func setTitle(title: String, subtitle: String) {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = R.color.butlerColors.darkerText()
        titleLabel.font = R.font.gothamHTFMedium(size: 15)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clearColor()
        subtitleLabel.textColor = R.color.butlerColors.darkText()
        subtitleLabel.font = R.font.gothamHTFLight(size: 11)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let tv = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        tv.addSubview(titleLabel)
        tv.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        if widthDiff > 0 {
            var frame = titleLabel.frame
            frame.origin.x = widthDiff / 2
            frame.makeIntegralInPlace()
            titleLabel.frame = frame
        } else {
            var frame = subtitleLabel.frame
            frame.origin.x = abs(widthDiff) / 2
            frame.makeIntegralInPlace()
            titleLabel.frame = frame
        }
        
        titleView = tv
    }
}