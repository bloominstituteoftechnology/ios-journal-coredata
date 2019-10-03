//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Casualty on 10/2/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    @IBOutlet weak var tableViewCellTitleLabel: UILabel!
    
    @IBOutlet weak var tableViewCellTimestampLabel: UILabel!
    
    @IBOutlet weak var tableViewCellBodyTextLabel: UILabel!
    
    
        var entry: Entry? {
            didSet {
                updateViews()
            }
        }
        
        func updateViews() {
            guard let entry = entry,
                let timestamp = entry.timestamp else { return }
            
            tableViewCellTitleLabel.text = entry.title
            tableViewCellBodyTextLabel.text = entry.bodyText
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy, hh:mm a"
            self.tableViewCellTimestampLabel.text = dateFormatter.string(from: timestamp)
        }

    }
