//
//  SendRequestViewController.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit
import RealmSwift

class SendRequestViewController: UITableViewController {
    
    let tableViewDatasource = SendRequestTableViewDatasource()
    
    override func viewDidLoad() {
        tableView.dataSource = tableViewDatasource
        tableView.keyboardDismissMode = .OnDrag
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80))
        
        let urlTextField = SemiBorderedTextField(frame: CGRect.zero)
        urlTextField.inset = 10
        urlTextField.borderColor = R.color.butlerColors.grayColor()
        urlTextField.borderStyle = .None
        urlTextField.autocorrectionType = .No
        urlTextField.autocapitalizationType = .None
        urlTextField.keyboardType = .URL
        urlTextField.returnKeyType = .Done
        urlTextField.attributedPlaceholder = NSAttributedString(string: "URL", attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.8)])
        urlTextField.textColor = UIColor.whiteColor()
        
        containerView.addSubview(urlTextField)
        
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        urlTextField.textAlignment = NSTextAlignment.Center
        
        let slider = MultipleButtonSlider(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50), items: ["GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS", "SHIT BRICKS"], callback: nil)
        slider.backgroundColor = UIColor.greenColor()
        slider.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = slider
        
        NSLayoutConstraint.activateConstraints([
            urlTextField.topAnchor.constraintEqualToAnchor(containerView.topAnchor, constant: 20),
            urlTextField.bottomAnchor.constraintEqualToAnchor(containerView.bottomAnchor, constant: -20),
            urlTextField.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 20),
            urlTextField.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor, constant: -20)
            ])
        
        tableView.backgroundView = UIImageView(image: R.image.sendRequestBackground())
        
        super.viewDidLoad()
    }
}
