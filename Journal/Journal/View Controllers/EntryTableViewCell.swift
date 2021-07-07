//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Thomas Cacciatore on 6/10/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    
    private func updateViews() {
        guard let entry = entry else { return }
        titleLabel.text = entry.title
        bodyLabel.text = entry.bodyText
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let dateAsString = dateFormatter.string(from: entry.timeStamp!)
        timeStampLabel.text = dateAsString
    }
    
    
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

}
