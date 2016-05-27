//
//  ResponseViewController.swift
//  Butler
//
//  Created by Max Kramer on 27/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

final class ResponseViewController: UIViewController {
    let response: Response
    
    init(_ response: Response) {
        self.response = response
        
        print("cookies => ", self.response.cookies())
        
        let nibResource = R.nib.responseViewController
        super.init(nibName: nibResource.name, bundle: nibResource.bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}