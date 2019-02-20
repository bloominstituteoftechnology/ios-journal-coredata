//
//  EntryTableViewCell.swift
//  Core Data Journal
//
//  Created by Jaspal on 2/18/19.
//  Copyright © 2019 Jaspal Suri. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var entryTitle: UILabel!
    
    @IBOutlet weak var bodyText: UILabel!
    
    @IBOutlet weak var timestamp: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let entry = entry,
            let timestamp = entry.timestamp else { return }
        
        entryTitle.text = entry.title
        bodyText.text = entry.bodyText
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy, hh:mm a"
        self.timestamp.text = dateFormatter.string(from: timestamp)
    }

}
