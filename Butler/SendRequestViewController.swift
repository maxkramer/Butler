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
    var urlTextField: SemiBorderedTextField!
    
    func configureTextField() {
        urlTextField = SemiBorderedTextField(frame: CGRect.zero)
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
        urlTextField.delegate = self
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        urlTextField.textAlignment = NSTextAlignment.Center
    }
    
    func configureTableView() {
        tableViewDatasource = SendRequestTableViewDatasource(self.tableView)
        tableView.dataSource = tableViewDatasource
        tableView.delegate = tableViewDatasource
        tableView.keyboardDismissMode = .OnDrag
        tableView.backgroundView = UIImageView(image: R.image.sendRequestBackground())
    }
    
    func generateSlider(items: [String], callback: MultipleButtonSlider.ButtonTapped) -> MultipleButtonSlider {
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
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }
    
    func requestMethodSliderCallback(index: Int) {
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
    }
    
    func generateTableHeaderView() -> (headerView: UIView, constraints: [NSLayoutConstraint]) {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 110))
        
        containerView.addSubview(urlTextField)
        
        let topSlider = generateSlider(RequestMethod.allMethods().map { return $0.rawValue }, callback: requestMethodSliderCallback)
        containerView.addSubview(topSlider)
        
        let constraints: [NSLayoutConstraint] = [
            urlTextField.topAnchor.constraintEqualToAnchor(containerView.topAnchor, constant: 20),
            urlTextField.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 20),
            urlTextField.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor, constant: -20),
            urlTextField.heightAnchor.constraintEqualToConstant(40),
            topSlider.topAnchor.constraintEqualToAnchor(urlTextField.bottomAnchor, constant: 20),
            topSlider.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 20),
            topSlider.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor, constant: -20),
            topSlider.bottomAnchor.constraintEqualToAnchor(containerView.bottomAnchor, constant: -10)
        ]
        
        return (containerView, constraints)
    }
    
    func bodyFormatSliderCallback(index: Int) {
        if index == 0 {
            self.workingRequest.rawBodyFormat = BodyFormat.Plain.rawValue
        } else {
            self.workingRequest.rawBodyFormat = BodyFormat.JSON.rawValue
        }
    }
    
    func generateTableFooterView() -> (footerView: UIView, constraints: [NSLayoutConstraint]) {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        
        let bottomSlider = generateSlider(BodyFormat.allFormats().map { return $0.rawValue }, callback: bodyFormatSliderCallback)
        containerView.addSubview(bottomSlider)
        
        let constraints: [NSLayoutConstraint] = [
            bottomSlider.topAnchor.constraintEqualToAnchor(containerView.topAnchor, constant: 0),
            bottomSlider.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 20),
            bottomSlider.bottomAnchor.constraintEqualToAnchor(containerView.bottomAnchor, constant: 0)
        ]
        
        return (containerView, constraints)
    }
    
    override func viewDidLoad() {
        configureTableView()
        configureTextField()
        
        let tableHeader = generateTableHeaderView()
        tableView.tableHeaderView = tableHeader.headerView
        
        let tableFooter = generateTableFooterView()
        tableView.tableFooterView = tableFooter.footerView
        
        NSLayoutConstraint.activateConstraints(tableHeader.constraints + tableFooter.constraints)
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        workingRequest.url = textField.text ?? ""
        return true
    }
}
