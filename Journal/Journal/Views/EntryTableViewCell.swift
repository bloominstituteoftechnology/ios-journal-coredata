//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Kelson Hartle on 5/17/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "EntryCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var journalTitleLabel: UILabel!
    @IBOutlet weak var journalDateLabel: UILabel!
    @IBOutlet weak var journalTextEntryLabel: UILabel!
    
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
   private func updateViews() {
    guard let entry = entry else { return }
    
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "MM-dd-YY, hh-mm"
    let now = dateFormatter.string(from: entry.timeStamp!)
    
    
    journalTitleLabel.text = entry.title
    journalDateLabel.text = now
    journalTextEntryLabel.text = entry.bodyText
    
    
    
    
    }

}
