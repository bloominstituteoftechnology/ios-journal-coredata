//
//  EntryTableViewCell.swift
//  JournalCoreDataHW
//
//  Created by Michael Flowers on 5/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    @IBOutlet weak var entryTitlelabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    
    private func updateViews(){
        guard let passedInEntry = entry else { return }
        entryTitlelabel.text = passedInEntry.title
        bodyLabel.text = passedInEntry.bodyText
        
        if let date = passedInEntry.timestamp {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            timestampLabel.text = formatter.string(from: date)
        }
    }
}
