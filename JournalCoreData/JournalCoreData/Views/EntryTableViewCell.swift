//
//  EntryTableViewCell.swift
//  JournalCoreData
//
//  Created by Nelson Gonzalez on 2/11/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func updateViews(){
        guard let entries = entry else {return}
        titleLabel.text = entries.title
        if let date = entries.timestamp {
        dateLabel.text = .dateToString(date: date)
        }
        descriptionLabel.text = entries.bodyText
    }

}
