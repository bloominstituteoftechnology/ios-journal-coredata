//
//  EntryTableViewCell.swift
//  journal-coredata
//
//  Created by Karen Rodriguez on 3/23/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryTimestamp: UILabel!
    @IBOutlet weak var entryText: UILabel!

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    // MARK: - Private methods
    
    private func updateViews() {
        guard let entry = entry else { return }
        entryTitleLabel.text = entry.title
        entryText.text = entry.bodyText
        
        // Format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy, hh:mm a"
        
        entryTimestamp.text = dateFormatter.string(from: entry.timestamp!)
    }
}
