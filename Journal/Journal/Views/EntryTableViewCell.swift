//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by John Kouris on 9/30/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var bodyText: UILabel!
    
    let dateFormatter = DateFormatter()
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        titleLabel.text = entry?.title
        bodyText.text = entry?.bodyText
        
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let timestamp = dateFormatter.string(from: entry?.timestamp ?? Date())
        timestampLabel.text = timestamp
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
