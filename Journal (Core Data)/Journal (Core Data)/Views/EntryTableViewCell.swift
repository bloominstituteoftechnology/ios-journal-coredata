//
//  EntryTableViewCell.swift
//  Journal (Core Data)
//
//  Created by Alex Shillingford on 9/16/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    let df = DateFormatter()

    func updateViews() {
        df.dateFormat = "MM-dd-yyyy"
        guard let entry = entry else { return }
        guard let timeStamp = entry.timeStamp else { return }
        titleLabel.text = entry.title
        descriptionLabel.text = entry.bodyText
        dateLabel.text = df.string(from: timeStamp)
    }
}
