//
//  Authorization+CoreDataProperties.swift
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

extension Authorization {
    @NSManaged var method: String
    @NSManaged var username: String
    @NSManaged var password: String
    @NSManaged var request: Request?
    
    enum AuthorizationMethod: String {
        case Basic
    }
    
    var authorizationString: String? {
        let authorization = "\(username):\(password)"
        
        if let encodedAuth = authorization.dataUsingEncoding(NSASCIIStringEncoding)?.base64EncodedStringWithOptions([]) {
            return "Basic \(encodedAuth)"
        }
        return nil
    }
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(AuthorizationMethod.Basic.rawValue, forKey: "method")
    }
}
