//
//  EntriesTableViewCell.swift
//  Journal
//
//  Created by Percy Ngan on 10/14/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import UIKit

class EntriesTableViewCell: UITableViewCell {

	@IBOutlet weak var titleTextField: UILabel!
	@IBOutlet weak var bodyTextField: UILabel!
	@IBOutlet weak var timestampTextField: UILabel!

	// MARK: - Properties
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

	func updateViews() {
		guard let entry = entry else { return }

		titleTextField.text = entry.title
		bodyTextField.text = entry.bodyText

		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US")
		dateFormatter.dateStyle = .short
		dateFormatter.timeStyle = .short
		timestampTextField.text = dateFormatter.string(from: entry.timestamp!)

	}
}
