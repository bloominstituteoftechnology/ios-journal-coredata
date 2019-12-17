//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Lambda_School_Loaner_218 on 12/16/19.
//  Copyright © 2019 Lambda_School_Loaner_218. All rights reserved.
//

// commit 
import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var entry: Entry? {
        didSet{
            updateViews()
        }
    }
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    private func updateViews() {
        guard let entry = entry, let timestamp = entry.timestamp else { return }
        titleLabel.text = entry.title
        bodyLabel.text = entry.bodytext
        dateLabel.text = dateFormatter.string(from: timestamp)
        
    }
}
