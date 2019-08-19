//
//  EntryTableViewCell.swift
//  Journal-CoreData
//
//  Created by Marlon Raskin on 8/19/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var bodyLabel: UILabel!


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
		titleLabel.text = entry?.title
		bodyLabel.text = entry?.bodyText
		dateLabel.text = "\(entry?.timeStamp ?? Date())"
	}
}
