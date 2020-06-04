//
//  EntryTableViewCell.swift
//  journal-coredata
//
//  Created by Rob Vance on 6/2/20.
//  Copyright © 2020 Robs Creations. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    // Mark: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var entryDetailLabel: UILabel!

    // Mark: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    static let reuseIdentifier = "EntryCell"
    
    func updateViews() {
        guard let entry = entry else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY, hh:mm"
        let currentTime = dateFormatter.string(from: entry.timestamp ?? Date())
        titleLabel.text = entry.title
        dateLabel.text = currentTime
        entryDetailLabel.text = entry.bodyText
    }

}
