//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Juan M Mariscal on 4/22/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    var entry: Entry? {
        didSet{
            updateViews()
        }
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    
    func updateViews() {
        if let title = entry?.title,
            let date = entry?.timestamp,
            let notes = entry?.bodyText {
            titleLabel.text = title
            dateLabel.text = date.toString(dateFormat: "MM/dd/yy, h:mm a")
            notesLabel.text = notes
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

}
