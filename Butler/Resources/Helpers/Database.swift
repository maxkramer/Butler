//
//  Database.swift
//  Butler
//
//  Created by Max Kramer on 31/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation
import AERecord

extension Database {
    enum Notification: String {
        case RequestSentSuccessfully
        
        var name: String {
            return rawValue
        }
        
        static func notificationNames() -> [String] {
            return [Notification.RequestSentSuccessfully.rawValue]
        }
    }
}

import CoreData

final class Database: NSObject {
    static private let shared = Database()
    
    func configureDatabase() {
        guard let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd") else {
            Cerberus.error("[DB]: Model does not exist in bundle")
            fatalError()
        }
        
        let mom = NSManagedObjectModel(contentsOfURL: modelURL)!
        let model: NSManagedObjectModel = NSManagedObjectModel(byMergingModels: [mom])!
        let myStoreType = NSSQLiteStoreType
        let myStoreURL = AERecord.storeURLForName("Database")
        let myOptions = [NSMigratePersistentStoresAutomaticallyOption : true]
        do {
            try AERecord.loadCoreDataStack(managedObjectModel: model, storeType: myStoreType, configuration: nil, storeURL: myStoreURL, options: myOptions)
        } catch {
            Cerberus.error("[DB]: Error configuring database: \(error)")
        }
        
        //        AERecord.truncateAllData()
    }
    
    private func store(request: Request) {
        do {
            try AERecord.mainContext.save()
            Cerberus.trace("[DB]: Inserted \(request)")
        } catch {
            Cerberus.error("[DB]: Unable to insert \(request): \(error)")
        }
    }
    
    class func store(request: Request) {
        shared.store(request)
    }
    
    class func configure() {
        shared.configureDatabase()
        
        Notification.notificationNames().forEach {
            NSNotificationCenter.defaultCenter().addObserver(shared, selector: #selector(received(_:)), name: $0, object: nil)
        }
    }
    
    @objc private func received(notification: NSNotification) {
        guard let notif = Notification(rawValue: notification.name) else { return }
        switch notif {
        case .RequestSentSuccessfully:
            if let request = notification.object as? Request {
                Database.store(request)
            }
            break
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(Database.shared)
    }
}