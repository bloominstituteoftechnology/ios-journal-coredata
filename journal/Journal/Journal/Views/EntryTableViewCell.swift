//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Ian French on 6/3/20.
//  Copyright © 2020 Ian French. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var entryTitleLabel: UILabel!
    
    @IBOutlet weak var entryDateLabel: UILabel!
    
    @IBOutlet weak var entryDetailLabel: UILabel!
    
    static let reuseIdentifier = "EntryCell"
    var entry: Entry? {
        didSet {
            updateViews()
        }
        
    }
    
    
    func updateViews() {
        
        guard let entry = entry else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM,dd/YY, hh:mm"
        let currentDateInfo = dateFormatter.string(from: entry.timestamp ?? Date())
        
        // assign label texts
        entryTitleLabel.text = entry.title
        entryDateLabel.text = currentDateInfo
        entryDetailLabel.text = entry.bodyText
    }
    

    

}
