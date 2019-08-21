//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Kat Milton on 7/22/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var entryPreviewLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    func updateViews() {
        nameLabel.text = entry?.title
        entryPreviewLabel.text = entry?.bodyText
        
        guard let dateToFormat = entry?.timeStamp else { return }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .long
        let formattedDate = formatter.string(from: dateToFormat)
        
        dateLabel.text = formattedDate
    }

}
