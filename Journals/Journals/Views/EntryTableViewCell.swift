//
//  EntryTableViewCell.swift
//  Journals
//
//  Created by Gladymir Philippe on 8/5/20.
//  Copyright © 2020 Gladymir Philippe. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    static let reuseIdentifier = "TaskCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var entryDetailLabel: UILabel!
    
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func updateViews() {
        guard let entry = entry else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY, hh:mm a"
        let currentTime = dateFormatter.string(from: entry.timestamp ?? Date())
        titleLabel.text = entry.title
        dateLabel.text = currentTime
        entryDetailLabel.text = entry.bodyText
    }
}
