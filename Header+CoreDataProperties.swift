//
//  Header+CoreDataProperties.swift
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

extension Header: KeyValueObject {
    @NSManaged var key: String
    @NSManaged var value: String
    @NSManaged var request: Request?
    
}
