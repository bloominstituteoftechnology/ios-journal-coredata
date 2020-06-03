//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Kenneth Jones on 6/3/20.
//  Copyright © 2020 Kenneth Jones. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var entryBody: UILabel!
    @IBOutlet weak var entryDate: UILabel!
    
    static let reuseIdentifier = "EntryCell"
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let entry = entry,
            let entryTimestamp = entry.timestamp else { return }
        
        entryTitle.text = entry.title
        entryBody.text = entry.bodyText
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, hh:mm a"
        entryDate.text = formatter.string(from: entryTimestamp)
    }

}
