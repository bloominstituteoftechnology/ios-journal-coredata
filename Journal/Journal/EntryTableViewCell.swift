//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Jeremy Taylor on 6/3/19.
//  Copyright © 2019 Bytes Random L.L.C. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var entryTextLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let entry = entry else { return }
        titleLabel.text = entry.title
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        timestampLabel.text = formatter.string(from: entry.timestamp!)
        entryTextLabel.text = entry.bodyText
    }
    
    
}
