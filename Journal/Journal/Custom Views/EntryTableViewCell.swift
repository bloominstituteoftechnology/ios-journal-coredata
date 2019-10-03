//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Jessie Ann Griffin on 10/1/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    // MARK: Properties
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
    
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        entryTitleLabel.text = entry?.title
        summaryLabel.text = entry?.bodyText
        
        if let date = entry?.timeStamp {
            timeStampLabel.text = dateFormatter.string(from: date)
        }
    }
}
