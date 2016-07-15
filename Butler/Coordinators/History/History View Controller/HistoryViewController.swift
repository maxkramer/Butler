//
//  HistoryViewController.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit
import CoreData

import AECoreDataUI
import AERecord

protocol HistoryViewControllerDelegate {
    func historyViewController(historyViewController: HistoryViewController, needsDisplayRequest request: Request)
}

class HistoryViewController: CoreDataTableViewController {
    var delegate: HistoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
    }
    
    func refreshData() {
        let sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let request = Request.createFetchRequest(sortDescriptors: sortDescriptors)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: AERecord.defaultContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") ?? UITableViewCell(style: .Subtitle, reuseIdentifier: "Cell")
        
        if let frc = fetchedResultsController {
            if let object = frc.objectAtIndexPath(indexPath) as? Request {
                cell.textLabel?.text = "\(object.requestMethod.uppercaseString) \(object.url)"
                cell.detailTextLabel?.text = "\(object.creationDate) Authentication: \(object.authorization?.method ?? "none")"
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let delegate = delegate,
            frc = fetchedResultsController,
            request = frc.objectAtIndexPath(indexPath) as? Request else {
            return
        }
        delegate.historyViewController(self, needsDisplayRequest: request)
    }
}