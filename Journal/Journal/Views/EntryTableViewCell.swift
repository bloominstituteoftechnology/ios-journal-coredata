//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Sean Acres on 7/22/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var entryBodyText: UILabel!
    @IBOutlet weak var entryTimestamp: UILabel!
    
    let dateFormatter = DateFormatter()
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        entryTitle.text = entry?.title
        entryBodyText.text = entry?.bodyText
        
        dateFormatter.dateFormat = "MM/dd/yy h:mm a"
        if let date = entry?.timestamp {
            entryTimestamp.text = dateFormatter.string(from: date)
        }
    }

}
