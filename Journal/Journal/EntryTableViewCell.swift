//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Harmony Radley on 4/20/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    // bodyTextLabel
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    static let reuseIdentifier = "EntryCell"
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var dateFormatter: DateFormatter = {
        let newDate = DateFormatter()
        newDate.calendar = .current
        newDate.dateFormat = "MM-dd-yyyy h:mm a"
        return newDate
    }()
    
    func updateViews() {
        guard let entry = entry else { return }
        
        titleLabel.text = entry.title
        dateLabel.text = dateFormatter.string(from: entry.timestamp!)
        bodyTextLabel.text = entry.bodyText
    }

}
