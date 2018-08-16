//
//  EntryTableViewCell.swift
//  Journal (Core Data)
//
//  Created by Linh Bouniol on 8/13/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyTextLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    
    func updateViews() {
        guard let title = entry?.title, let bodyText = entry?.bodyText, let timestamp = entry?.timestamp else { return }
        
        titleLabel?.text = title
        bodyTextLabel?.text = bodyText
        
        // Get date formatter
        let dateFormatter = DateFormatter()
        
        // Set the style
        dateFormatter.dateStyle = .short    // 8/13/18
        dateFormatter.timeStyle = .short    // 1:28 PM
        
        // Convert the type Date to String
        let date = dateFormatter.string(from: timestamp)
        
        timestampLabel?.text = date
    }
}
