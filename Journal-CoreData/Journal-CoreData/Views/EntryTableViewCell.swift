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

	var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		return formatter
	}

	var entry: Entry? {
		didSet {
			updateViews()
		}
	}


	private func updateViews() {
		titleLabel.text = entry?.title
		bodyLabel.text = entry?.bodyText
		dateLabel.text = "\(dateFormatter.string(from: entry?.timeStamp ?? Date()))"
	}
}
