//
//  MultipleButtonSlider+Butler.swift
//  Butler
//
//  Created by Max Kramer on 18/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

extension MultipleButtonSlider {
    static func butlerSlider(items: [String], callback: MultipleButtonSlider.ButtonTapped) -> MultipleButtonSlider {
        let slider = MultipleButtonSlider(frame: CGRect.zero, items: items, callback: callback)
        slider.sliderColor = R.color.butlerColors.lightText()
        slider.sliderUnderlayColor = R.color.butlerColors.darkerText()
        slider.defaultButtonAttributes = [
            NSFontAttributeName: R.font.gothamHTFBook(size: 15)!,
            NSForegroundColorAttributeName: R.color.butlerColors.lightText()
        ]
        slider.selectedButtonAttributes = [
            NSFontAttributeName: R.font.gothamHTFMedium(size: 15)!,
            NSForegroundColorAttributeName: R.color.butlerColors.lightText()
        ]
        return slider
    }
}