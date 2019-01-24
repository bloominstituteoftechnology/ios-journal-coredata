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
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews(){
        guard let entry = entry else { return }
        // https://stackoverflow.com/questions/42524651/convert-nsdate-to-string-in-ios-swift/42524788
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "MM-dd-yyyy hh:mm a"
        
        let dateString = formatter.string(from: yourDate!)
        titleLabel.text = entry.title
        timestampLabel.text = dateString
        bodyTextLabel.text = entry.bodyText
        moodLabel.text = entry.mood
    }
}
