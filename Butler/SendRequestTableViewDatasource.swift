//
//  SendRequestTableViewDatasource.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

class SendRequestTableViewDatasource: NSObject, UITableViewDataSource, UITableViewDelegate, ButtonTableHeaderViewDelegate {
    
    var showingAuthorizationCells = false
    let tableView: UITableView
    
    var sectionTitles = [
        "Authorization: none",
        "Headers",
        "Parameters",
        "Body format"
    ]
    
    var headers = [Header]()
    var parameters = [Parameter]()
    var authorization = Authorization()
    
    func generateRequest() -> Request {
        return Request.create(headers, parameters: parameters, authorization: showingAuthorizationCells ? authorization : nil)
    }
    
    init(_ tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.registerForCellsAndHeaders()
    }
    
    func registerForCellsAndHeaders() {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.registerNib(R.nib.singleTextFieldCell(), forCellReuseIdentifier: "SingleTextFieldCell")
        tableView.registerNib(R.nib.doubleTextFieldCell(), forCellReuseIdentifier: "DoubleTextFieldCell")
        tableView.registerNib(R.nib.buttonTableHeaderView(), forHeaderFooterViewReuseIdentifier: "ButtonTableHeaderView")
        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "DefaultHeaderFooterView")
        
        tableView.estimatedSectionHeaderHeight = 30
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return showingAuthorizationCells ? 2 : 0
        } else if section == 1 {
            return headers.count
        } else if section == 2 {
            return parameters.count
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("ButtonTableHeaderView") as? ButtonTableHeaderView else {
            return nil
        }
        
        let titleFont = R.font.gothamHTFBook(size: 15)
        let titleColor = R.color.butlerColors.lightText()
        let text = sectionTitles[section]
        
        headerView.tag = section
        if section < 3 {
            headerView.button.tintColor = UIColor.lightTextColor()
            headerView.delegate = self
            headerView.button.hidden = false
        } else {
            headerView.button.hidden = true
        }
        
        if section == 0 {
            let minorAttributes = [
                NSFontAttributeName: titleFont!,
                NSForegroundColorAttributeName: titleColor
            ]
            
            let majorAttributes = [
                NSFontAttributeName: R.font.gothamHTFMedium(size: 15)!,
                NSForegroundColorAttributeName: titleColor
            ]
            
            let minorAttributedString = NSMutableAttributedString(string: "Authorization: ", attributes: minorAttributes)
            let majorAttributedString = NSAttributedString(string: showingAuthorizationCells ? "basic" : "none", attributes: majorAttributes)
            
            minorAttributedString.appendAttributedString(majorAttributedString)
            headerView.titleLabel.attributedText = minorAttributedString
            
            headerView.button.selected = showingAuthorizationCells
        } else {
            headerView.titleLabel.text = text
            headerView.titleLabel.textColor = titleColor
            headerView.titleLabel.font = titleFont
        }
        
        headerView.contentView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    func buttonTableHeaderViewDelegate(wasTapped headerFooterView: ButtonTableHeaderView) {
        let section = headerFooterView.tag
        if section == 0 {
            let indexPaths = [
                NSIndexPath(forRow: 0, inSection: 0),
                NSIndexPath(forRow: 1, inSection: 0)
            ]
            
            showingAuthorizationCells = !showingAuthorizationCells
            
            let isCurrentlyShowingAuthorizationCells = !showingAuthorizationCells
            if isCurrentlyShowingAuthorizationCells {
                tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Left)
                sectionTitles[section] = "Authorization: none"
            } else {
                tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
                sectionTitles[section] = "Authorization: basic"
            }
            tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
        } else if section == 1 {
            headers.append(Header())
            
            let indexPath = NSIndexPath(forRow: headers.count - 1, inSection: 1)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
            
        } else if section == 2 {
            parameters.append(Parameter())
            
            let indexPath = NSIndexPath(forRow: parameters.count - 1, inSection: 2)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
        }
    }
    
    func executeDeletion(action: UITableViewRowAction, indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            headers.removeAtIndex(indexPath.row)
        } else if indexPath.section == 2 {
            parameters.removeAtIndex(indexPath.row)
        }
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        guard indexPath.section == 1 || indexPath.section == 2 else {
            return nil
        }
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: executeDeletion)
        
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == 1 || indexPath.section == 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let keyFont = R.font.gothamHTFLight(size: 14)
        let keyColor = R.color.butlerColors.darkText()
        
        let valueFont = R.font.gothamHTFBook(size: 14)
        let valueColor = R.color.butlerColors.darkText()
        
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCellWithIdentifier("SingleTextFieldCell", forIndexPath: indexPath) as? SingleTextFieldCell {
                let keys = ["username", "password"]
                let placeholders = ["username", "password"]
                cell.keyLabel.text = keys[indexPath.row]
                cell.keyLabel.font = keyFont
                cell.keyLabel.textColor = keyColor
                
                cell.valueTextField.font = valueFont
                cell.valueTextField.textColor = valueColor
                cell.valueTextField.placeholder = placeholders[indexPath.row]
                cell.valueTextField.text = authorization.password ?? ""
                
                cell.textChangedHandler = { [unowned self] tf, text in
                    self.authorization.password = text
                }
                
                cell.selectionStyle = .None
                return cell
            }
        } else if indexPath.section == 1 || indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCellWithIdentifier("DoubleTextFieldCell", forIndexPath: indexPath) as? DoubleTextFieldCell {
                let item: Header = indexPath.section == 1 ? headers[indexPath.row] : parameters[indexPath.row]
                cell.keyTextField.text = item.key
                cell.keyTextField.font = keyFont
                cell.keyTextField.textColor = keyColor
                
                cell.valueTextField.font = valueFont
                cell.valueTextField.textColor = valueColor
                cell.valueTextField.text = item.value
                cell.selectionStyle = .None
                cell.textChangedHandler = { [unowned self] textField, newText in
                    if textField == cell.keyTextField {
                        item.key = newText
                    } else if textField == cell.valueTextField {
                        item.value = newText
                    }
                    
                    if indexPath.section == 1 {
                        self.headers[indexPath.row] = item
                    } else {
                        self.parameters[indexPath.row] = item as! Parameter
                    }
                }
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        return cell
    }
}
