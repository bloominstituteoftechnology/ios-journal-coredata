//
//  EntryTableViewCell.swift
//  Journal (Core Data)
//
//  Created by Michael on 1/27/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

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
    
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryTimestampLabel: UILabel!
    @IBOutlet weak var entryBodyTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateViews() {
        guard let entry = entry else { return }
        
        entryTitleLabel.text = entry.title
        entryTimestampLabel.text = dateFormatter.string(from: entry.timestamp ?? Date())
        entryBodyTextLabel.text = entry.bodyText
    }
}
