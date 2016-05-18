//
//  SemiBorderedTextField.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

class SemiBorderedTextField: UITextField {
    
    var borderColor: UIColor = UIColor.blackColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var inset: CGFloat = 0
    @IBInspectable var borderWidth: CGFloat = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let cutoutMultiplier: CGFloat = 0.25
        
        let cutoutWidth = cutoutMultiplier * rect.width
        
        let pathWidth = rect.width - cutoutWidth
        
        let leftPath = UIBezierPath()
        leftPath.moveToPoint(CGPoint(x: rect.minX, y: rect.minY))
        leftPath.addLineToPoint(CGPoint(x: pathWidth / 2, y: rect.minY))
        leftPath.moveToPoint(CGPoint(x: rect.minX, y: rect.minY))
        leftPath.addLineToPoint(CGPoint(x: rect.minX, y: rect.height))
        leftPath.moveToPoint(CGPoint(x: rect.minX, y: rect.height))
        leftPath.addLineToPoint(CGPoint(x: pathWidth / 2, y: rect.height))
        
        let rightPath = UIBezierPath()
        rightPath.moveToPoint(CGPoint(x: rect.width, y: rect.minY))
        rightPath.addLineToPoint(CGPoint(x: rect.maxX - pathWidth / 2, y: rect.minY))
        rightPath.moveToPoint(CGPoint(x: rect.maxX, y: rect.minY))
        rightPath.addLineToPoint(CGPoint(x: rect.maxX, y: rect.height))
        rightPath.moveToPoint(CGPoint(x: rect.maxX, y: rect.height))
        rightPath.addLineToPoint(CGPoint(x: rect.maxX - pathWidth / 2, y: rect.height))
        
        leftPath.lineWidth = borderWidth
        leftPath.lineCapStyle = .Round
        
        rightPath.lineWidth = borderWidth
        rightPath.lineCapStyle = .Round
        
        borderColor.setStroke()
        
        leftPath.stroke()
        rightPath.stroke()
    }
    
}
