//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Shawn James on 4/20/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    func updateViews() {
        guard let entry = entry else { return }
        
        titleLabel.text = entry.title
        
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mm a"
            return dateFormatter
        }()
        dateLabel.text = dateFormatter.string(from: entry.timestamp!) // TODO: dateformatting
        
        bodyTextLabel.text = entry.bodyText ?? "No Content" // FIXME: - <-- empty string if body is empty
    }
    
}
