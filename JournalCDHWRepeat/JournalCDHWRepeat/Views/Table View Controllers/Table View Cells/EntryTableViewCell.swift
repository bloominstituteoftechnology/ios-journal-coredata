//
//  EntryTableViewCell.swift
//  JournalCDHWRepeat
//
//  Created by Michael Flowers on 6/3/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    private func updateViews(){
        guard let passedInEntry = entry else { return }
        titleLabel.text = passedInEntry.title
        bodyLabel.text = passedInEntry.bodyText
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        if let date = passedInEntry.timestamp {
            dateLabel.text = formatter.string(from: date)
        }
    }
    
}
