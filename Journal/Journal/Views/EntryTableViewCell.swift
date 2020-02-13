//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Gerardo Hernandez on 2/12/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    // MARK: Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateViews() {
        guard let entry = entry,
            let timestamp = entry.timestamp else { return }
        
        let formatter = DateFormatter()
       formatter.dateFormat = "MM/dd/yyyy"
        
        entryTitleLabel.text = entry.title
        bodyTextLabel.text = entry.bodyText
        timeStamp.text = formatter.string(from: timestamp)
    }

}
