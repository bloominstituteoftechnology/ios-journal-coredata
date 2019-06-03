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
        
        guard let entry = entry,
            let date = entry.timestamp else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy, HH:mm"
        let formattedDate = dateFormatter.string(from: date)
        
        entryLabel.text = entry.title
        bodyTextLabel.text = entry.bodyText
        timestampLabel.text = formattedDate
        
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
