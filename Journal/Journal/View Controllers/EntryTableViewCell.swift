//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by denis cedeno on 12/4/19.
//  Copyright © 2019 DenCedeno Co. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

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
        formatter.dateFormat = "M/d/yy h:mm a"
        return formatter
    }
    
    private func updateViews() {
        guard let entry = entry,
            let timeStamp = entry.timeStamp else { return }
        let timeString = dateFormatter.string(from: timeStamp)
        titleLabel.text = entry.title
        bodyTextLabel.text = entry.bodyText
        timeStampLabel.text = timeString
    }

}
