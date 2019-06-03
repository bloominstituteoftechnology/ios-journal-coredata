//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Mitchell Budge on 6/3/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        guard let entry = entry,
        let timestamp = entry.timestamp else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy h:mm a"
        let formattedTimestamp = dateFormatter.string(from: timestamp)
        titleLabel.text = entry.title
        bodyLabel.text = entry.bodyText
        timestampLabel.text = formattedTimestamp
    }

    // MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
}
