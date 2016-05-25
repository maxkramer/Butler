//
//  ProgressAlertView.swift
//  Butler
//
//  Created by Max Kramer on 25/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

final class ProgressAlertView: UIView {
    private static let shared: ProgressAlertView = ProgressAlertView()
    
    class func show() {
        shared.show()
    }
    
    class func hide() {
        shared.hide()
    }
    
    var appWindow: UIWindow {
        return UIApplication.sharedApplication().keyWindow!
    }
    
    private lazy var darkenedBackground: UIView = {
        let darkenBG = UIView()
        darkenBG.backgroundColor = UIColor.blackColor()
        darkenBG.alpha = 0.4
        darkenBG.translatesAutoresizingMaskIntoConstraints = false
        return darkenBG
    }()
    
    private func loadingView() -> LoadingView {
        let loading = LoadingView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100)))
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.tintColor = R.color.butlerColors.lightText()
        loading.layer.cornerRadius = 10.0
        loading.layer.masksToBounds = true
        return loading
    }
    
    private var currentLoadingView: LoadingView?
    
    private func show() {
        darkenedBackground.alpha = 0.0
        
        currentLoadingView = loadingView()
        currentLoadingView!.alpha = 0.0
        
        UIApplication.sharedApplication().keyWindow!.addSubview(darkenedBackground)
        UIApplication.sharedApplication().keyWindow!.addSubview(currentLoadingView!)
        
        NSLayoutConstraint.activateConstraints([
            darkenedBackground.leadingAnchor.constraintEqualToAnchor(appWindow.leadingAnchor),
            darkenedBackground.trailingAnchor.constraintEqualToAnchor(appWindow.trailingAnchor),
            darkenedBackground.topAnchor.constraintEqualToAnchor(appWindow.topAnchor),
            darkenedBackground.bottomAnchor.constraintEqualToAnchor(appWindow.bottomAnchor),
            currentLoadingView!.centerXAnchor.constraintEqualToAnchor(appWindow.centerXAnchor),
            currentLoadingView!.centerYAnchor.constraintEqualToAnchor(appWindow.centerYAnchor),
            currentLoadingView!.widthAnchor.constraintEqualToConstant(125),
            currentLoadingView!.heightAnchor.constraintEqualToConstant(125)
            ])
        
        UIView.animateWithDuration(0.15) {
            self.darkenedBackground.alpha = 0.4
            self.currentLoadingView!.alpha = 1.0
        }
    }
    
    private func hide() {
        UIView.animateWithDuration(0.15, animations: {
            self.darkenedBackground.alpha = 0
            self.currentLoadingView?.alpha = 0
            }, completion: { _ in
                self.darkenedBackground.removeFromSuperview()
                self.currentLoadingView?.removeFromSuperview()
        })
    }
}