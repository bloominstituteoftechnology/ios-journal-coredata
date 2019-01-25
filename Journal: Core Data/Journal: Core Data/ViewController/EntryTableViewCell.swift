//
//  EntryTableViewCell.swift
//  Journal: Core Data
//
//  Created by Ivan Caldwell on 1/22/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    
    let dateFormat = DateFormat()
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews(){
        guard let entry = entry else { return }
        titleLabel.text = entry.title
        timestampLabel.text = entry.formattedTimeStamp
        bodyTextLabel.text = entry.bodyText
        moodLabel.text = entry.mood
    }
}
