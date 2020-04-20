//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Hunter Oppel on 4/20/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "EntryCell"
    
    var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let entry = entry,
            let timestamp = entry.timestamp else { return }
        
        titleLabel.text = entry.title
        entryLabel.text = entry.bodyText
        let entryTimestamp = dateFormatter.string(from: timestamp)
        timestampLabel.text = entryTimestamp
    }
}
