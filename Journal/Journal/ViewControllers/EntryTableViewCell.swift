//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Hector Steven on 5/28/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

	
	private func setupViews() {
		guard let entry = entry else { return }
		
		titleLabel?.text = entry.title
//		timestampLabel?.text = entry.timeStamp
		timestampLabel?.text = "timeStamp"
		bodyLabel?.text = entry.bodyText
		
	}
	
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var timestampLabel: UILabel!
	@IBOutlet var bodyLabel: UILabel!
	var entry: Entry? { didSet{ setupViews() } }
}
