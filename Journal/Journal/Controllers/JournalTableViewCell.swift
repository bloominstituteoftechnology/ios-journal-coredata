//
//  JournalTableViewCell.swift
//  Journal
//
//  Created by Joseph Rogers on 12/4/19.
//  Copyright © 2019 Moka Apps. All rights reserved.
//

import UIKit

class JournalTableViewCell: UITableViewCell {
    
    //MARK: Properties

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var entry: Entry? { didSet { updateViews() } }
        
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
            
            let formatter = DateFormatter()
            formatter.dateFormat = "mm/dd/yy, hh:mm a"
            titleLabel.text = entry.title
            detailLabel.text = entry.bodyText
            dateLabel.text = formatter.string(from: entry.timestamp ?? Date())
        }
    }

