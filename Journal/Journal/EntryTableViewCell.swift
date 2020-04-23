//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Morgan Smith on 4/22/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var entryTitle: UILabel!
    
    @IBOutlet weak var entryDate: UILabel!
    
    @IBOutlet weak var entryDes: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        entryTitle.text = entry.title
        //entryDate.text = String(entry.timestamp)
        entryDes.text = entry.bodyText
    }
    
    
}
