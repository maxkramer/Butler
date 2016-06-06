//
//  Database.swift
//  Butler
//
//  Created by Max Kramer on 31/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation
import RealmSwift

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

final class Database: NSObject {
    static private let shared = Database()
    
    var realm: Realm!
    
    func configureDefaultRealm() {
        let config = Realm.Configuration(encryptionKey: KeychainHelper.shared.realmEncryptionKey())
        realm = try? Realm(configuration: config)
        
        Cerberus.info("Realm Database URL: \(Realm.Configuration.defaultConfiguration.fileURL!)")
    }
    
    private func store(request: Request) {
        guard let realm = realm else {
            Cerberus.error("Unable to access Realm. try? Realm failed")
            return
        }
        
        do {
            try realm.write {
                realm.add(request)
                Cerberus.debug("Stored \(request)")
            }
        } catch {
            Cerberus.error(error)
        }
    }
    
    class func store(request: Request) {
        shared.store(request)
    }
    
    class func configure() {
        shared.configureDefaultRealm()
        
        Notification.notificationNames().forEach {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(received(_:)), name: $0, object: nil)
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
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}