//
//  SendRequestViewController.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit
import RealmSwift

class SendRequestViewController: UITableViewController, UITextFieldDelegate {
    
    
    var workingRequest = Request()
    
    var tableViewDatasource: SendRequestTableViewDatasource!
    
    override func viewDidLoad() {
        tableViewDatasource = SendRequestTableViewDatasource(self.tableView)
        
        tableView.dataSource = tableViewDatasource
        tableView.delegate = tableViewDatasource
        
        tableView.keyboardDismissMode = .OnDrag
        
        var containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 110))
        
        let urlTextField = SemiBorderedTextField(frame: CGRect.zero)
        urlTextField.inset = 10
        urlTextField.borderColor = R.color.butlerColors.gray()
        urlTextField.borderStyle = .None
        urlTextField.autocorrectionType = .No
        urlTextField.autocapitalizationType = .None
        urlTextField.keyboardType = .URL
        urlTextField.returnKeyType = .Done
        urlTextField.attributedPlaceholder = NSAttributedString(string: "URL", attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.8)])
        urlTextField.textColor = R.color.butlerColors.lightText()
        urlTextField.font = R.font.gothamHTFLight(size: 15)
        
        containerView.addSubview(urlTextField)
        
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        urlTextField.textAlignment = NSTextAlignment.Center
        
        var slider = MultipleButtonSlider(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0), items: ["GET", "POST", "PUT", "DELETE"], callback: { [unowned self] index in
            var requestMethod: RequestMethod?
            switch index {
            case 0:
                requestMethod = .GET
                break
            case 1:
                requestMethod = .POST
                break
            case 2:
                requestMethod = .PUT
                break
            case 3:
                requestMethod = .DELETE
                break
            default:
                break
            }
            if let requestMethod = requestMethod {
                self.workingRequest.rawRequestMethod = requestMethod.rawValue
            }
            })
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
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(slider)
        
        tableView.tableHeaderView = containerView
        
        NSLayoutConstraint.activateConstraints([
            urlTextField.topAnchor.constraintEqualToAnchor(containerView.topAnchor, constant: 20),
            urlTextField.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 20),
            urlTextField.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor, constant: -20),
            urlTextField.heightAnchor.constraintEqualToConstant(40),
            slider.topAnchor.constraintEqualToAnchor(urlTextField.bottomAnchor, constant: 20),
            slider.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 20),
            slider.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor, constant: -20),
            slider.bottomAnchor.constraintEqualToAnchor(containerView.bottomAnchor, constant: -10)
            ])
        
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        slider = MultipleButtonSlider(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50), items: ["PLAIN", "JSON"], callback: { [unowned self] index in
            if index == 0 {
                self.workingRequest.rawBodyFormat = BodyFormat.Plain.rawValue
            } else {
                self.workingRequest.rawBodyFormat = BodyFormat.JSON.rawValue
            }
            })
        
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
        slider.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(slider)
        tableView.tableFooterView = containerView
        
        NSLayoutConstraint.activateConstraints([
            slider.topAnchor.constraintEqualToAnchor(containerView.topAnchor, constant: 0),
            slider.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 20),
            slider.bottomAnchor.constraintEqualToAnchor(containerView.bottomAnchor, constant: 0)
            ])
        
        tableView.backgroundView = UIImageView(image: R.image.sendRequestBackground())
        
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        workingRequest.url = textField.text ?? ""
        return true
    }
}
