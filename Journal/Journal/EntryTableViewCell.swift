//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Dennis Rudolph on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        
        nameLabel.text = entry?.title
        descriptionLabel.text = entry?.bodyText
        timeLabel.text = formatter.string(from: entry?.timestamp ?? Date())
    }

}

