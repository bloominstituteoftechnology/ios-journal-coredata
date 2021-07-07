//
//  EntryTableViewCell.swift
//  ios-Journal-coredata
//
//  Created by Jonalynn Masters on 10/15/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    // MARK: - Outlets
    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var entryDescription: UILabel!
    @IBOutlet weak var entryTimeStamp: UILabel!
    
    func updateViews() {
        
        entryTitle?.text = entry?.title
        entryDescription.text = entry?.bodyText
        
        if let timestamp = entry?.timestamp {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        entryTimeStamp.text = dateFormatter.string(from: timestamp)
        }
    }
}
