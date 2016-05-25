//
//  RotatingCircle.swift
//  RPLoadingAnimation
//
//  Created by naoyashiga on 2015/10/11.
//  Copyright © 2015年 naoyashiga. All rights reserved.
//

import UIKit

protocol RPLoadingAnimationDelegate: class {
    func setup(layer: CALayer, size: CGSize, color: UIColor)
}

class RotatingCircle: UIView, RPLoadingAnimationDelegate {
    
    var replicatorLayer: CAReplicatorLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        replicatorLayer?.frame = frame
    }
    
    override var tintColor: UIColor! {
        didSet {
            if let replicatorLayer = replicatorLayer {
                replicatorLayer.sublayers?.forEach {
                    $0.backgroundColor = tintColor.CGColor
                }
            }
        }
    }
    
    func setup(layer: CALayer, size: CGSize, color: UIColor) {
        let dotNum: CGFloat = 5
        let diameter: CGFloat = size.width / 10
        
        let circle = CALayer()
        let frame = CGRect(
            x: (layer.bounds.width - diameter) / 2,
            y: (layer.bounds.height - diameter) / 2,
            width: diameter,
            height: diameter
        )
        
        circle.backgroundColor = color.CGColor
        circle.cornerRadius = diameter / 2
        circle.frame = frame
        
        replicatorLayer = CAReplicatorLayer()
        replicatorLayer!.frame = layer.bounds
        layer.addSublayer(replicatorLayer!)
        
        replicatorLayer!.addSublayer(circle)
        replicatorLayer!.instanceCount = Int(dotNum)
        replicatorLayer!.instanceTransform = CATransform3DMakeTranslation(20, 0, 0)
        
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.toValue = frame.origin.y + 50
        animation.duration = 0.5
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        circle.addAnimation(animation, forKey: "animation")
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = 0.8
        scaleAnimation.duration = 0.5
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = .infinity
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        circle.addAnimation(scaleAnimation, forKey: "scaleAnimation")
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = -2.0 * M_PI
        rotationAnimation.duration = 6.0
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        replicatorLayer!.addAnimation(rotationAnimation, forKey: "rotationAnimation")
        
        replicatorLayer!.instanceDelay = 0.1
        
        let angle = (2.0 * M_PI) / Double(replicatorLayer!.instanceCount)
        replicatorLayer!.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
    }
}
