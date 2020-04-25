//
//  EntryTableViewCell.swift
//  ios-journal-coredata
//
//  Created by De MicheliStefano on 13.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    
    private func updateViews() {
        if let entry = entry {
            titleLabel?.text = entry.title
            bodyTextLabel?.text = entry.bodyText
            dateLabel?.text = convertDateToString(for: entry.timestamp)
        }
    }
    
    private func convertDateToString(for date: Date?) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm"
        if let date = date {
            return df.string(from: date)
        } else {
            return ""
        }
    }
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
}
