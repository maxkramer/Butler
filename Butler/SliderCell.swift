//
//  SliderCell.swift
//  Butler
//
//  Created by Max Kramer on 18/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

class SliderCell: UITableViewCell {
    typealias SliderValueChanged = (textField: UITextField, newText: String) -> Void
    
    @IBOutlet weak var slider: MultipleButtonSlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        slider.callback = sliderValueChanged
    }
    
    func sliderValueChanged(idx: Int) {
        
    }
    
    override func prepareForReuse() {
        slider.selectedIndex = 0
    }
}
