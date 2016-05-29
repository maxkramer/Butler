//
//  ResponseTableViewDatasource.swift
//  Butler
//
//  Created by Max Kramer on 27/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

final class ResponseTableViewDatasource: NSObject, UITableViewDataSource, UITableViewDelegate {
    enum Section: Int {
        case Headers = 0
        case Cookies
        
        static func count() -> Int {
            return 2
        }
        
        static func sectionTitles() -> [String] {
            return ["Headers", "Cookies"]
        }
    }
    
    let response: Response
    let cookies: [NSHTTPCookie]?
    let sectionTitles = Section.sectionTitles()
    
    init(response: Response, tableView: UITableView) {
        self.response = response
        self.cookies = response.cookies()
        
        tableView.estimatedSectionHeaderHeight = 30
        tableView.estimatedRowHeight = 30
        
        tableView.registerNib(R.nib.buttonTableHeaderView(), forHeaderFooterViewReuseIdentifier: "ButtonTableHeaderView")
        tableView.registerNib(R.nib.singleTextFieldCell(), forCellReuseIdentifier: "SingleTextFieldCell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let count = cookies?.count where count > 0 {
            return Section.count()
        }
        return Section.count() - 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.Headers.rawValue:
            return response.httpResponse?.allHeaderFields.count ?? 0
        case Section.Cookies.rawValue:
            if let cookies = cookies {
                return cookies.count
            }
            return 0
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection sectionInt: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("ButtonTableHeaderView") as? ButtonTableHeaderView else {
            return nil
        }
        
        let titleFont = R.font.gothamHTFBook(size: 14)
        let titleColor = R.color.butlerColors.lightText()
        
        headerView.button.hidden = true
        
        headerView.titleLabel.text = sectionTitles[sectionInt]
        headerView.titleLabel.textColor = titleColor
        headerView.titleLabel.font = titleFont
        
        headerView.contentView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("SingleTextFieldCell", forIndexPath: indexPath) as? SingleTextFieldCell {
            
            let section = Section(rawValue: indexPath.section)!
            if section == Section.Headers {
                if let index = response.httpResponse?.allHeaderFields.startIndex.advancedBy(indexPath.row) {
                    let key = response.httpResponse?.allHeaderFields.keys[index]
                    let value = response.httpResponse?.allHeaderFields[key!]
                    
                    cell.keyLabel.text = key as? String
                    cell.valueTextField.text = value as? String
                }
            } else if section == Section.Cookies {
                if let cookie = cookies?[indexPath.row] {
                    cell.keyLabel.text = cookie.name
                    cell.valueTextField.text = cookie.value.stringByRemovingPercentEncoding
                }
            }
            
            cell.keyLabel.numberOfLines = 2
            
            let keyFont = R.font.gothamHTFLight(size: 12)
            let keyColor = R.color.butlerColors.darkText()
            
            let valueFont = R.font.gothamHTFBook(size: 12)
            let valueColor = R.color.butlerColors.darkText()
            
            cell.keyLabel.font = keyFont
            cell.keyLabel.textColor = keyColor
            
            cell.valueTextField.font = valueFont
            cell.valueTextField.textColor = valueColor
            cell.valueTextField.userInteractionEnabled = false
            
            cell.selectionStyle = .None
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        if action == #selector(NSObject.copy(_:)) {
            return true
        }
        return false
    }
    
    func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        let pasteboard = UIPasteboard.generalPasteboard()
        let section = Section(rawValue: indexPath.section)!
        
        if section == .Headers {
            if let index = response.httpResponse?.allHeaderFields.startIndex.advancedBy(indexPath.row) {
                guard let key = response.httpResponse?.allHeaderFields.keys[index] as? String,
                    value = response.httpResponse?.allHeaderFields[key] as? String else {
                        return
                }
                
                pasteboard.string = "\(key): \(value)"
            }
        } else if section == .Cookies {
            guard let cookie = cookies?[indexPath.row] else {
                return
            }
            
            pasteboard.string = "\(cookie.name)=\(cookie.value)"
        }
    }
}