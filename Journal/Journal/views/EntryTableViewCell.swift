//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by ronald huston jr on 5/18/20.
//  Copyright © 2020 HenryQuante. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    static let reuseIdentifier = "EntryCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    
    var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    static let resuseIdentifier = "EntryCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
