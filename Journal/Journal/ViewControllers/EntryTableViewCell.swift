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
		
		let formated = DateFormatter()
		formated.dateFormat = "yyyy-MM-dd  hh:mm a"
		
		timestampLabel?.text = formated.string(from: entry.timeStamp!)
		
		bodyLabel?.text = entry.bodyText
		
	}
	
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var timestampLabel: UILabel!
	@IBOutlet var bodyLabel: UILabel!
	var entry: Entry? { didSet{ setupViews() } }
}
