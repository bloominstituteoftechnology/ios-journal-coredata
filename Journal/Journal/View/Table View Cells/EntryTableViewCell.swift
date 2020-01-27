//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Kenny on 1/27/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    var entry: Entry?
    
    func updateViews() {
        guard let entry = entry else {return}
        titleLabel.text = entry.title
        bodyTextLabel.text = entry.bodyText
        formatDate()
    }
    
    func formatDate() {
        guard let timestamp = entry?.timestamp else {return}
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        let dateString = df.string(from: timestamp)
        dateLabel.text = dateString
    }

}
