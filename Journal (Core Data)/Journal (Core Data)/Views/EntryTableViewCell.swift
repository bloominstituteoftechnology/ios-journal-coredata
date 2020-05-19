//
//  EntryTableViewCell.swift
//  Journal (Core Data)
//
//  Created by David Wright on 2/12/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    // MARK: - Properties

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    // MARK: - UpdateViews

    private func updateViews() {
        guard let entry = entry,
            let timestamp = entry.timestamp else { return }
        
        titleLabel.text = entry.title
        bodyTextLabel.text = entry.bodyText
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        timestampLabel.text = dateFormatter.string(from: timestamp)
    }

}
