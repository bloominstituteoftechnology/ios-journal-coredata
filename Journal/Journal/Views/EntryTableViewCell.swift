//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Matthew Martindale on 4/21/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
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
    @IBOutlet weak var notesLabel: UILabel!
    
    func updateViews() {
        if let title = entry?.title,
            let date = entry?.timestamp,
            let notes = entry?.bodyText {
            titleLabel.text = title
            dateLabel.text = date.toString(dateFormat: "MM/dd/yy, h:mm a")
            notesLabel.text = notes
        }
    }
    
}
