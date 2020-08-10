//
//  UITableViewCell.swift
//  Journal
//
//  Created by Dojo on 8/5/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    static var reuseIdentifier = "EntryCell"
    
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
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
    
    
    private func updateViews() {
        
        guard let entry = entry else { return }
        
        entryTitleLabel.text = entry.title
        descriptionLabel.text = entry.bodyText
        timeLabel.text = dateFormatter.string(from: entry.timestamp!)
        
    }
}
