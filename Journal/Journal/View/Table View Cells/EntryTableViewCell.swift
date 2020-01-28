//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Kenny on 1/27/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: view methods
    private func updateViews() {
        guard let entry = entry else {return}
        titleLabel.text = entry.title
        bodyTextLabel.text = entry.bodyText
        guard let timestamp = entry.timestamp else{return}
        dateLabel.text = Utility.formattedDate(date: timestamp)
    }

}
