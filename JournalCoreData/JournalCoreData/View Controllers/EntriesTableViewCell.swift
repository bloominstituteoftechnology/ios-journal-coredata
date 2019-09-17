//
//  EntriesTableViewCell.swift
//  JournalCoreData
//
//  Created by Marc Jacques on 9/16/19.
//  Copyright © 2019 Marc Jacques. All rights reserved.
//

import UIKit

class EntriesTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var entry : Entry? {
        didSet{
            updateViews()
        }
    }
    
    
    func updateViews() {
        guard let entry = entry else { return }
        titleLabel.text = entry.title
        detailLabel.text = entry.bodyText
        dateLabel.text = theDateIs.string(from: entry.timeStamp)
        
        
    }
    
    var theDateIs: DateFormatter {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return dateFormatter
    }

}
