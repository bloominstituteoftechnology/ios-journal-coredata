//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-11.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - UI Elements
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    // MARK: - Methods
    
    func updateViews() {
        guard let entry = entry else {
            print("No entry from which to update for cell!")
            return
        }
        
        titleLabel.text = entry.title ?? ""
        timestampLabel.text = "\(entry.timestamp ?? Date())"
        bodyLabel.text = entry.bodyText ?? ""
    }
}
