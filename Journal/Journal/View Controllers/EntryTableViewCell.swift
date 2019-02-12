//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Moses Robinson on 2/11/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

import UIKit
import CoreData

class EntryTableViewCell: UITableViewCell {

    private func updateViews() {
        guard let entry = entry else { return }
        
        titleLabel.text = entry.title
        bodyTextLabel.text = entry.bodyText
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy, h:mm a"
        let entryDate = dateFormatter.string(from: entry.timestamp!)
        
        timestampLabel.text = entryDate
    }
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyTextLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
}
