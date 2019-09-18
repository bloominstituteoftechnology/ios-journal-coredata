//
//  EntryCell.swift
//  MyJournal
//
//  Created by Jeffrey Santana on 8/19/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {

	//MARK: - IBOutlets
	
	@IBOutlet weak var titleLbl: UILabel!
	@IBOutlet weak var dateLbl: UILabel!
	@IBOutlet weak var storyLbl: UILabel!
	
	//MARK: - Properties
	
	var entry: Entry? {
		didSet {
			updateViews()
		}
	}
	
	private var dateFormatter: DateFormatter {
		let dateFormatter = DateFormatter()
		
		dateFormatter.dateStyle = .short
		dateFormatter.timeStyle = .short
		
		return dateFormatter
	}
	
	//MARK: - IBActions
	
	
	//MARK: - Helpers
	
	private func updateViews() {
		guard let entry = entry, let lastUpdated = entry.lastUpdated else { return }
		
		titleLbl.text = entry.title
		dateLbl.text = dateFormatter.string(from: lastUpdated)
		storyLbl.text = entry.story
	}
	
}
