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
    var callback: ButtonTapped?
    
    let interItemSpacing: CGFloat = 20
    
    var sliderColor: UIColor = UIColor.blueColor() {
        didSet {
            sliderView.backgroundColor = sliderColor
        }
    }
    
    var sliderUnderlayColor: UIColor = UIColor.grayColor() {
        didSet {
            sliderUnderlayView.backgroundColor = sliderUnderlayColor
        }
    }
    
    var defaultButtonAttributes: [String : AnyObject]? {
        didSet {
            updateTitleAttributes()
        }
    }
    
    var selectedButtonAttributes: [String: AnyObject]? {
        didSet {
            updateTitleAttributes()
        }
    }
    
    private var sliderOffset: CGFloat = 10
    private var sliderHeight: CGFloat = 1
    
    var selectedIndex = 0 {
        didSet {
            moveSlider(selectedIndex)
        }
    }
    
    private var itemButtons = [UIButton]()
    private var sliderView: UIView!
    private var sliderUnderlayView: UIView!
    
    private var sliderLeadingConstraint: NSLayoutConstraint!
    private var sliderWidthConstraint: NSLayoutConstraint!
    
    init(frame: CGRect, items: [String], callback: ButtonTapped?) {
        self.items = items
        self.callback = callback
        super.init(frame: frame)
        
        createButtons()
        createStackView()
        createSliderUnderlay()
        createSlider()
        
        createStackLayoutConstraints()
        createButtonLayoutConstraints()
        createSliderUnderlayConstraints()
        createSliderLayoutConstraints()
        
        performSelector(#selector(MultipleButtonSlider.moveSlider(_:)), withObject: 0, afterDelay: 0.1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var stackView: UIStackView!
    
    func createStackView() {
        stackView = UIStackView(arrangedSubviews: itemButtons)
        stackView.alignment = .Fill
        stackView.distribution = .EqualSpacing
        stackView.axis = .Horizontal
        stackView.spacing = interItemSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
    }
    
    func createSliderUnderlay() {
        sliderUnderlayView = UIView()
        sliderUnderlayView.backgroundColor = sliderUnderlayColor
        sliderUnderlayView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sliderUnderlayView)
        sendSubviewToBack(sliderUnderlayView)
    }
    
    func createSliderUnderlayConstraints() {
        NSLayoutConstraint.activateConstraints([
            sliderUnderlayView.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
            sliderUnderlayView.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
            sliderUnderlayView.topAnchor.constraintEqualToAnchor(sliderView.topAnchor),
            sliderUnderlayView.bottomAnchor.constraintEqualToAnchor(sliderView.bottomAnchor)
            ])
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
        
        for (idx, title) in items.enumerate() {
            let button = UIButton(type: .Custom)
            button.setTitle(title, forState: .Normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(MultipleButtonSlider.tappedButton(_:)), forControlEvents: .TouchUpInside)
            
            if idx == 0 {
                button.contentHorizontalAlignment = .Left
            } else if idx == items.count - 1 {
                button.contentHorizontalAlignment = .Right
            } else {
                button.contentHorizontalAlignment = .Center
            }
            itemButtons.append(button)
        }
    }
    
    func tappedButton(sender: UIButton) {
        guard let index = itemButtons.indexOf(sender) where index != selectedIndex else {
            return
        }
        
        selectedIndex = index
        
        moveSlider(index)
        
        updateTitleAttributes()
        
        if let callback = callback {
            callback(index: index)
        }
    }
    
    func moveSlider(toIndex: Int) {
        updateConstraints()
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: {
            self.layoutIfNeeded()
            }, completion: nil)
    }
    
    func updateTitleAttributes() {
        for (idx, button) in itemButtons.enumerate() {
            let title = button.titleForState(.Normal) ?? ""
            if idx == selectedIndex {
                button.setAttributedTitle(NSAttributedString(string: title, attributes: selectedButtonAttributes), forState: .Normal)
            } else {
                button.setAttributedTitle(NSAttributedString(string: title, attributes: defaultButtonAttributes), forState: .Normal)
            }
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        let button = itemButtons[selectedIndex]
        sliderWidthConstraint.constant = button.frame.width
        sliderLeadingConstraint.constant = button.frame.minX
    }
    
    func createStackLayoutConstraints() {
        NSLayoutConstraint.activateConstraints([
            stackView.topAnchor.constraintEqualToAnchor(topAnchor),
            stackView.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
            stackView.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
            stackView.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: -(sliderHeight + sliderOffset))
            ])
    }
    
    func createSliderLayoutConstraints() {
        sliderLeadingConstraint = sliderView.leadingAnchor.constraintEqualToAnchor(leadingAnchor)
        sliderWidthConstraint = sliderView.widthAnchor.constraintEqualToConstant(0)
        
        NSLayoutConstraint.activateConstraints([
            sliderLeadingConstraint,
            sliderWidthConstraint,
            sliderView.topAnchor.constraintEqualToAnchor(stackView.bottomAnchor, constant: sliderOffset),
            sliderView.bottomAnchor.constraintEqualToAnchor(bottomAnchor)
            ])
    }
    
    func createButtonLayoutConstraints() {
        for (idx, button) in itemButtons.enumerate() {
            var constraints = [NSLayoutConstraint]()
            
            constraints += [
                button.heightAnchor.constraintEqualToAnchor(stackView.heightAnchor)
            ]
            
            if idx > 0 {
                constraints += [
                    button.heightAnchor.constraintEqualToAnchor(stackView.heightAnchor),
                ]
            }
            
            NSLayoutConstraint.activateConstraints(constraints)
        }
    }
}
