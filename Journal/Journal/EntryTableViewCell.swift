//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Kobe McKee on 6/3/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let entry = entry,
            let date = entry.timeStamp else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy, HH:mm"
        let formattedDate = dateFormatter.string(from: date)
        
        titleLabel.text = entry.title
        timeStampLabel.text = formattedDate
        bodyLabel.text = entry.bodyText
    }

    
    
    
}
