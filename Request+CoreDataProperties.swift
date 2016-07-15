//
//  Request+CoreDataProperties.swift
//  
//
//  Created by Max Kramer on 06/06/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Request {
    
    @NSManaged var requestMethod: String
    @NSManaged var bodyFormat: String
    @NSManaged var favourited: NSNumber
    @NSManaged var url: String
    @NSManaged var authorization: Authorization?
    @NSManaged var headers: NSSet
    @NSManaged var parameters: NSSet
    @NSManaged var creationDate: NSDate
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        requestMethod = RequestMethod.GET.rawValue
        bodyFormat = BodyFormat.Plain.rawValue
        favourited = NSNumber(bool: false)
        creationDate = NSDate()
    }
    
}
