//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Jake Connerly on 8/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets & Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yy, h:mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    
    // MARK: - Methods
    
    private func updateViews() {
        guard let entry = entry,
              let date = entry.timeStamp else { return }
        
        titleLabel.text = entry.title
        bodyTextLabel.text = entry.bodyText
        timeStampLabel.text = dateFormatter.string(from: date)
    }

}

