//
//  SingleTextFieldCell.swift
//  Butler
//
//  Created by Max Kramer on 18/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

class SingleTextFieldCell: UITableViewCell {
    typealias TextChangedHandler = (textField: UITextField, newText: String) -> Void
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    var textChangedHandler: TextChangedHandler?
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        guard let handler = textChangedHandler else {
            return true
        }
        
        let originalString = textField.text ?? "" as NSString
        let newString = originalString.stringByReplacingCharactersInRange(range, withString: string)
        
        handler(textField: textField, newText: newString)
        return true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        keyLabel.text = nil
        valueTextField.text = nil
        textChangedHandler = nil
    }
}
