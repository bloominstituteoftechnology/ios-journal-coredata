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
    
    journalTitleLabel.text = entry.title
    //journalDateLabel.text = String(entry.timeStamp)
    journalTextEntryLabel.text = entry.bodyText
    
    
    
    
    }

}
