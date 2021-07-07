//
//  EntryTableViewCell.swift
//  Journal - Day 2
//
//  Created by Sameera Roussi on 6/2/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    // MARK: - Update cell with Entry fields
    private func updateView() {
        // Don't have a journal entry- skip out.
        guard let entry = entry else { return }
        
        // Got one!  Show it!
        titleLabel.text = entry.title ?? ""
        bodyLabel.text = entry.bodyText
        
        // Format the date and put it in a string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy h:mm a"
        
        timestampLabel.text = dateFormatter.string(from: entry.timestamp ?? Date())
        
    }
    
    // MARK: - Properties
    var entry: Entry? { didSet {updateView()} }
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
}
