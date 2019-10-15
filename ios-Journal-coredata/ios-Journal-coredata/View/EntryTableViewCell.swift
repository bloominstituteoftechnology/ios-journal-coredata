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
        
        guard let timestamp = entryTimeStamp,
            let entryTimeStamp = entry?.timestamp else { return }
        timestamp.text = String("\(entryTimeStamp)")
        
    }
}
