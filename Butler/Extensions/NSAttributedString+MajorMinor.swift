//
//  NSAttributedString+MajorMinor.swift
//  Butler
//
//  Created by Max Kramer on 19/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

extension NSAttributedString {
    convenience init(majorString: String, minorString: String) {
        let titleFont = R.font.gothamHTFBook(size: 15)
        let titleColor = R.color.butlerColors.lightText()
        
        let minorAttributes = [
            NSFontAttributeName: titleFont!,
            NSForegroundColorAttributeName: titleColor
        ]
        
        let majorAttributes = [
            NSFontAttributeName: R.font.gothamHTFMedium(size: 15)!,
            NSForegroundColorAttributeName: titleColor
        ]
        
        let minorAttributedString = NSMutableAttributedString(string: minorString, attributes: minorAttributes)
        let majorAttributedString = NSAttributedString(string: majorString, attributes: majorAttributes)
        
        minorAttributedString.appendAttributedString(majorAttributedString)
        self.init(attributedString: minorAttributedString)
    }
}
