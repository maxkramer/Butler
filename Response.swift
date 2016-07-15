//
//  Response.swift
//  
//
//  Created by Max Kramer on 12/07/2016.
//
//

import Foundation
import CoreData


class Response: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    var httpResponse: NSHTTPURLResponse? {
        didSet {
            httpURLResponse = 
        }
    }
    
}
