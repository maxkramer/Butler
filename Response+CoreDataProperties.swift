//
//  Response+CoreDataProperties.swift
//  
//
//  Created by Max Kramer on 12/07/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Response {

    @NSManaged var httpURLResponse: NSData?
    @NSManaged var error: NSData?
    @NSManaged var date: NSDate?
    @NSManaged var timeTaken: NSNumber?
    @NSManaged var request: Request?

}
