//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Percy Ngan on 9/16/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var bodyLabel: UILabel!
	@IBOutlet weak var timestampLabel: UILabel!

	var entry: Entry? {
		didSet {
			updateViews()
		}
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	// MARK: - Properties

	func updateViews() {
		guard let entry = entry else { return }
		titleLabel.text = entry.title
		bodyLabel.text = entry.bodyText

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/dd/yy"
		timestampLabel.text = dateFormatter.string(from: entry.timestamp!)
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
