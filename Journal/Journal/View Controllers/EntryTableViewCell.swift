//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Thomas Dye on 4/22/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        guard let timestamp = entry?.timestamp,
              let title = entry?.title,
              let bodyText = entry?.bodyText else { return }
        
        titleLabel.text = title
        timeStampLabel.text = timestamp.description
        bodyTextLabel.text = bodyText
        
    }

}
