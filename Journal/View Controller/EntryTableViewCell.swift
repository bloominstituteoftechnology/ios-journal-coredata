//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Hayden Hastings on 6/3/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    // MARK: - methods
    
    private func updateViews() {
        entryLabel.text = entry?.title
        bodyTextLabel.text = entry?.bodyText
//        timestampLabel = entry?.timestamp
        
    }

    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
}
