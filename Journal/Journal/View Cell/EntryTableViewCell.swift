//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Norlan Tibanear on 8/9/20.
//  Copyright © 2020 Norlan Tibanear. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var entryLabel: UILabel!
    
    static let reuseIdentifier = "JournalCell"
    
    // Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let entry = entry else { return }
        
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm E, d MMM y"
        
        titleLabel.text = entry.title
        dateLabel.text = entry.timestamp?.description
        entryLabel.text = entry.bodyText
    }
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

} //
