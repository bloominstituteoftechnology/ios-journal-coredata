//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Chad Parker on 4/22/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func updateViews() {
        guard
            let entry = entry,
            let date = entry.timestamp else { fatalError() }
        
        titleLabel.text = entry.title
        dateLabel.text = dateFormatter.string(from: date)
        bodyTextLabel.text = entry.bodyText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
