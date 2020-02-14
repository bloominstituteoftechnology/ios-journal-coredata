//
//  EntryTableViewCell.swift
//  JournalCoreData
//
//  Created by John Holowesko on 2/13/20.
//  Copyright © 2020 John Holowesko. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    // MARK: - Functions
    
    func updateViews() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        titleLabel.text = entry?.title
        dateLabel.text = formatter.string(from: entry?.timestamp ?? Date())
        descriptionLabel.text = entry?.bodyText
    }
}
