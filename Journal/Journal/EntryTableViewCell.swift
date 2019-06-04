//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Jonathan Ferrer on 6/3/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {



    func updateViews() {
        titleLabel.text = entry?.title
        bodyLabel.text = entry?.bodyText

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        timestampLabel.text = dateFormatter.string(from: entry?.timestamp ?? Date())
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
}
