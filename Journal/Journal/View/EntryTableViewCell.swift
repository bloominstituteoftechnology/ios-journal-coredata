//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Blake Andrew Price on 12/5/19.
//  Copyright © 2019 Blake Andrew Price. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var previewLabel: UILabel!

    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy, h:mm a"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        return formatter
    }
    
    // MARK: - Functions
    private func updateViews() {
        guard let entry = entry else { return }
        
        titleLabel.text = entry.title
        timestampLabel.text = dateFormatter.string(from: entry.timestamp!)
        previewLabel.text = entry.bodyText
    }
}
