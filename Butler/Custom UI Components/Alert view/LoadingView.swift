//
//  LoadingView.swift
//  Butler
//
//  Created by Max Kramer on 25/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override var tintColor: UIColor! {
        didSet {
            if let animationView = animationView {
                animationView.tintColor = tintColor
            }
        }
    }
    
    private var animationView: RotatingCircle!
    
    func commonInit() {
        tintColor = R.color.butlerColors.darkText()
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurView)
        
        animationView = RotatingCircle()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(animationView)
        
        NSLayoutConstraint.activateConstraints([
            blurView.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
            blurView.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
            blurView.topAnchor.constraintEqualToAnchor(topAnchor),
            blurView.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
            animationView.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
            animationView.centerYAnchor.constraintEqualToAnchor(centerYAnchor),
            animationView.widthAnchor.constraintEqualToConstant(100),
            animationView.heightAnchor.constraintEqualToConstant(100)
            ])
        
        animationView.setup(layer, size: frame.size, color: tintColor)
    }
}
