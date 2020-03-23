//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Wyatt Harrell on 3/23/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    func updateViews() {
        guard let entry = entry else { return }
        titleLabel.text = entry.title
        descriptionLabel.text = entry.bodyText
        timeStampLabel.text = "\(entry.timestamp)"
        #warning("will need to be formatted")
    }
    
}
