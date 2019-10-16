//
//  EntryTableViewCell.swift
//  JournalCoreData
//
//  Created by admin on 10/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    
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
        
        guard let entry = entry else { return }
        
        entryTitleLabel.text = entry.title
        timeStampLabel.text = "\(String(describing: entry.timestamp))"
        bodyTextLabel.text = entry.bodyText
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
