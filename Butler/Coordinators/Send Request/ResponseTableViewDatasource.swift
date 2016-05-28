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
    
    init(response: Response, tableView: UITableView) {
        self.response = response
        self.cookies = response.cookies()
        //        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "some_identifier")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Section.count()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.Headers.rawValue:
            return response.httpResponse?.allHeaderFields.count ?? 0
        case Section.Cookies.rawValue:
            return cookies?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.sectionTitles()[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("some_identifier")
        if cell == nil {
            cell = UITableViewCell(style: .Value2, reuseIdentifier: "some_identifier")
        }
        
        let section = Section(rawValue: indexPath.section)!
        if section == Section.Headers {
            if let index = response.httpResponse?.allHeaderFields.startIndex.advancedBy(indexPath.row) {
                let key = response.httpResponse?.allHeaderFields.keys[index]
                let value = response.httpResponse?.allHeaderFields[key!]
                
                cell?.textLabel?.text = key as? String
                cell?.detailTextLabel?.text = value as? String
            }
        } else if section == Section.Cookies {
            if let cookie = cookies?[indexPath.row] {
                cell?.textLabel?.text = cookie.name
                cell?.detailTextLabel?.text = cookie.value.stringByRemovingPercentEncoding
            }
            
        }
        return cell!
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