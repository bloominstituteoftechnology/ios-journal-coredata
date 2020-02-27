//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Tobi Kuyoro on 27/01/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let entry = entry else { return }
        
        entryTitleLabel.text = entry.title
        bodyLabel.text = entry.bodyText
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yy, H:MM a"
        if let date = entry.timeStamp {
            dateLabel.text = formatter.string(from: date)
        }
    }
}
