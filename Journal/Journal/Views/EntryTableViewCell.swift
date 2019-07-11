//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Michael Stoffer on 7/10/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets and Properties
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var bodyTextLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            self.updateViews()
        }
    }
    
    private func updateViews() {
        guard let entry = self.entry else { return }
        self.titleLabel.text = entry.title
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        self.timestampLabel.text = formatter.string(from: entry.timestamp!)
        self.bodyTextLabel.text = entry.bodyText
    }
}
