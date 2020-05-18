//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Nonye on 5/18/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var journalTitleLabel: UILabel!
    @IBOutlet weak var journalEntryLabel: UILabel!
    @IBOutlet weak var journalEntryDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func updateViews() {
        journalTitleLabel.text = entry?.title
        journalEntryDate.text = "\(entry?.timeStamp)"
        journalEntryLabel.text = entry?.bodyText
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
