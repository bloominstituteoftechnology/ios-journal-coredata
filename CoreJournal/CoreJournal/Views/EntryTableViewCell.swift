//
//  EntryTableViewCell.swift
//  CoreJournal
//
//  Created by Aaron Cleveland on 1/27/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    func updateViews() {
        guard let entry = entry else { return }
        titleLabel.text = entry.title
        timeStampLabel.text = dateFormatter.string(from: entry.timestamp ?? Date())
        bodyLabel.text = entry.bodyText
    }

}
