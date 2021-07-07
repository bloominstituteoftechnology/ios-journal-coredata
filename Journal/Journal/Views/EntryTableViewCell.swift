//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Nathanael Youngren on 2/18/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    func updateViews() {
        guard let entry = entry,
        let timestamp = entry.timestamp else { return }
        titleLabel.text = entry.name
        detailsLabel.text = entry.bodyText
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy, hh:mm a"
        dateLabel.text = dateFormatter.string(from: timestamp)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
}
