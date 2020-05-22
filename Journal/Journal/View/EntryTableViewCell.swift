//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Stephanie Ballard on 5/18/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Outlets -
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryTimestampLabel: UILabel!
    @IBOutlet weak var entryBodyTextView: UILabel!
    
    // MARK: - Properties -
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    static let reuseIdentifier = "EntryCell"
    
    let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

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
        
        entryTitleLabel.text = entry.title
        entryBodyTextView.text = entry.bodyText
        let entryTimestamp = dateFormatter.string(from: timestamp)
        entryTimestampLabel.text = entryTimestamp
        
    }

}
