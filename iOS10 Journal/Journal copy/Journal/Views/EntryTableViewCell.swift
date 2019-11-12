//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by brian vilchez on 10/15/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    
    
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let entry = entry else {return}
        titleLabel.text = entry.title
        timeStamp.text = "\(entry.timeStamp)"
    }
}
