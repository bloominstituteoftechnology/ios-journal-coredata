//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Josh Kocsis on 6/3/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var articleLabel: UILabel!
    
    static let reuseIdentifier = "JournalCell"
    
    var entry: Entry? {
        didSet {
            updatViews()
        }
    }

    private func updatViews() {
        guard let entry = entry else { return }
//
//        var dateFormatted: String? {
//        let unixtimeInterval = 1480134638.0
//        let date = Date(timeIntervalSince1970: unixtimeInterval)
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
//        dateFormatter.locale = NSLocale.current
//        dateFormatter.dateFormat = "mm/dd/yyyy, HH:mm"
//        return dateFormatter.string(from: date)
//        }
        
        titleLabel.text = entry.title
        dateLabel.text = entry.timestamp?.description
        articleLabel.text = entry.bodyText
        
    }
}
