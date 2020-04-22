//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by David Williams on 4/21/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        
        titleLabel.text = entry.title
        dateLabel.text = entry.title
        entryLabel.text = entry.bodyText
    }
}
