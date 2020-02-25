//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Chris Gonzales on 2/24/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
     
    // MARK: - Properties
    
    var entry: Entry? {
        didSet{
            updateViews()
        }
    }
    
    // MARK: - Outlets

    @IBOutlet var entryTitleLabel: UITextField!
    @IBOutlet weak var entryDescriptionText: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    // MARK: - Methods
    
    private func updateViews(){
        guard let entry = entry else { return }
        entryTitleLabel.text = entry.title
        entryDescriptionText.text = entry.bodyText
        timeStamp.text = CustomDateFormatter.dateFormat(date: entry.timestamp!,
                                                        format: "MMM d, YYYY")
    }
}
