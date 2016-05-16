//
//  MultipleButtonSlider.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

class MultipleButtonSlider: UIView {
    
    typealias ButtonTapped = (index: Int) -> Void
    
    let items: [String]
    let callback: ButtonTapped?
    
    let interItemSpacing: CGFloat = 20
    
    var sliderColor: UIColor = UIColor.blueColor()
    var selectedIndex = 0
    
    private var itemButtons = [UIButton]()
    private var sliderView: UIView!
    
    private var sliderLeadingConstraint: NSLayoutConstraint!
    private var sliderTrailingConstraint: NSLayoutConstraint!
    
    init(frame: CGRect, items: [String], callback: ButtonTapped?) {
        self.items = items
        self.callback = callback
        super.init(frame: frame)
        
        self.createButtons()
        self.createSlider()
        
        createButtonLayoutConstraints()
        createSliderLayoutConstraints(itemButtons[selectedIndex])
        
        performSelector(#selector(MultipleButtonSlider.moveSlider(_:)), withObject: 0, afterDelay: 0.1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSlider() {
        sliderView = UIView()
        sliderView.backgroundColor = sliderColor
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sliderView)
    }
    
    func createButtons() {
        let n = items.count
        guard n > 0 else { return }
        
        items.forEach {
            let button = UIButton(type: .Custom)
            button.setTitle($0, forState: .Normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(MultipleButtonSlider.tappedButton(_:)), forControlEvents: .TouchUpInside)
            itemButtons.append(button)
            addSubview(button)
        }
    }
    
    func tappedButton(sender: UIButton) {
        guard let index = itemButtons.indexOf(sender) where index != selectedIndex else {
            return
        }
        
        selectedIndex = index
        
        moveSlider(index)
        
        if let callback = callback {
            callback(index: index)
        }
    }
    
    func moveSlider(toIndex: Int) {
        updateConstraints()
        UIView.animateWithDuration(0.15) {
            self.layoutIfNeeded()
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        let button = itemButtons[selectedIndex]
        sliderLeadingConstraint.constant = button.frame.minX
        sliderTrailingConstraint.constant = button.frame.width
    }
    
    func createSliderLayoutConstraints(button: UIButton) {
        sliderLeadingConstraint = sliderView.leadingAnchor.constraintEqualToAnchor(leadingAnchor)
        sliderTrailingConstraint = sliderView.widthAnchor.constraintEqualToConstant(0)
        
        NSLayoutConstraint.activateConstraints([
            sliderLeadingConstraint,
            sliderTrailingConstraint,
            sliderView.topAnchor.constraintEqualToAnchor(button.bottomAnchor),
            sliderView.bottomAnchor.constraintEqualToAnchor(bottomAnchor)
            ])
    }
    
    func createButtonLayoutConstraints() {
        for (idx, button) in itemButtons.enumerate() {
            var constraints = [NSLayoutConstraint]()
            if idx == 0 {
                constraints += [
                    button.leadingAnchor.constraintEqualToAnchor(leadingAnchor)
                ]
            } else if idx == itemButtons.count - 1 {
                constraints += [
                    button.leadingAnchor.constraintGreaterThanOrEqualToAnchor(itemButtons[idx - 1].trailingAnchor, constant: interItemSpacing),
                    button.trailingAnchor.constraintEqualToAnchor(trailingAnchor)
                ]
            } else {
                constraints += [
                    button.leadingAnchor.constraintGreaterThanOrEqualToAnchor(itemButtons[idx - 1].trailingAnchor, constant: interItemSpacing)
                ]
            }
            constraints += [
                button.topAnchor.constraintEqualToAnchor(topAnchor),
                button.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: -2)
            ]
            
            NSLayoutConstraint.activateConstraints(constraints)
        }
    }
}
