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
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
