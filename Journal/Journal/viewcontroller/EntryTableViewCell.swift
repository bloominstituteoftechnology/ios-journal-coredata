//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Vincent Hoang on 5/18/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import Foundation
import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        if let entry = entry {
            titleLabel.text = entry.title
            bodyLabel.text = entry.bodyText
            
            formatDate(entry)
        }
    }
    
    private func formatDate(_ entry: Entry) {
        if let timeStamp = entry.timeStamp {
            
            let df = DateFormatter()
            
            df.timeStyle = .short
            df.dateStyle = .short
            
            let date = df.string(from: timeStamp)
            
            dateLabel.text = date
        }
        
    }
}
