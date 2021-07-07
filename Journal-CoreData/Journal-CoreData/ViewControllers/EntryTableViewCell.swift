//
//  EntryTableViewCell.swift
//  Journal-CoreData
//
//  Created by Sameera Roussi on 5/27/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bodyTextView: UILabel!
    
    // MARK: Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    
    // MARK: Functions
    
    func updateViews() {
        titleLabel.text = entry?.title
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = "MM/dd/yyyy, hh:mm a"
        timeLabel.text = dateFormatterString.string(from: entry!.timestamp!)
        bodyTextView.text = entry?.bodyText
    }
    
    

}
