//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Tobi Kuyoro on 24/02/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // MARK: - Properties
    
    let dateFormatter = DateFormatter()
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Actions
    
    private func updateViews() {
        guard let entry = entry else { return }
        
        titleLabel.text = entry.title
        bodyTextLabel.text = entry.bodyText
        
        if let date = entry.timeStamp {
            dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
            let dateString = dateFormatter.string(from: date)
            dateLabel.text = dateString
        }
    }
}
