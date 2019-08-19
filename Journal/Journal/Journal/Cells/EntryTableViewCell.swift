//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Taylor Lyles on 8/19/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
	
	var entry: Entry? {
		didSet {
			updateViews()
		}
	}
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var bodyTextLabel: UILabel!
	@IBOutlet weak var timestampLabel: UILabel!
	
	func updateViews() {
		guard let timestamp = entry?.timestamp else { return }

		titleLabel.text = entry?.title
		bodyTextLabel.text = entry?.bodyText
		timestampLabel.text = "\(timestamp)"
	}
	

}
