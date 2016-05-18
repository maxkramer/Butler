//
//  ButtonTableHeaderView.swift
//  Butler
//
//  Created by Max Kramer on 18/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit

protocol ButtonTableHeaderViewDelegate {
    func buttonTableHeaderViewDelegate(wasTapped headerFooterView: ButtonTableHeaderView)
}

class ButtonTableHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak private(set) var titleLabel: UILabel!
    @IBOutlet weak private(set) var button: UIButton!
    
    var delegate: ButtonTableHeaderViewDelegate?
    
    @IBAction func tappedButton(sender: AnyObject) {
        guard let delegate = delegate else { return }
        delegate.buttonTableHeaderViewDelegate(wasTapped: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
        titleLabel.text = nil
        titleLabel.attributedText = nil
        
        button.setTitle(nil, forState: .Normal)
    }
}
