//
//  EntriesTableViewCell.swift
//  Journal
//
//  Created by Alex Thompson on 12/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class EntriesTableViewCell: UITableViewCell {
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var entryDescription: UILabel!
    @IBOutlet weak var entryTimeStamp: UILabel!
    
    func updateViews() {
        
        entryTitle?.text = entry?.title
        entryDescription.text = entry?.title
        
        guard let timestamp = entryTimeStamp,
        let entryTimeSetup = entry?.timestamp else { return }
        timestamp.text = String("\(entryTimeStamp)")
    }
}
