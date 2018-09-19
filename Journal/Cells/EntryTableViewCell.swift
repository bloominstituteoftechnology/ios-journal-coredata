//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Jason Modisett on 9/17/18.
//  Copyright © 2018 Jason Modisett. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    private func updateViews() {
        guard let entry = entry else { return }
        
        entryTitleLabel.text = entry.title
        entryContentLabel.text = entry.bodyText
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        let timestampString = formatter.string(from: entry.timestamp ?? Date())
        
        entryTimestampLabel.text = timestampString
    }
    
    var entry: Entry? { didSet { updateViews() }}
    
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryTimestampLabel: UILabel!
    @IBOutlet weak var entryContentLabel: UILabel!
    
}
