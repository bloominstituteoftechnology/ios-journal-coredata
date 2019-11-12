//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by morse on 11/10/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/yy h:mm a"
        return formatter
    }
    
    // MARK: - Setup
    
    private func updateViews() {
        
        guard let entry = entry, let timestamp = entry.timestamp else { return }
        
        let timeString = dateFormatter.string(from: timestamp)
        
        titleLabel.text = entry.title
        timeStampLabel.text = timeString
        bodyTextLabel.text = entry.bodyText
    }
}
