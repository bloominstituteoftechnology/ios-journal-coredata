//
//  EntryTableViewCell.swift
//  Journel
//
//  Created by Nathan Hedgeman on 8/22/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    //Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textBodyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//Functions
extension EntryTableViewCell {
    
    func updateViews() {
        guard let entry = entry else {return print("No Entry")}
        guard let timeStamp = entry.timeStamp else {return print("No timeStamp for entry")}
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .short
        self.titleLabel.text = entry.title?.uppercased()
        self.dateLabel.text = dateFormat.string(from: timeStamp)
        if entry.bodyText == "" {
            self.textBodyLabel.text = "(EMPTY)"
        } else {
            self.textBodyLabel.text = entry.bodyText
        }
        
        
    }
}

//Max character length
extension String {
    func maxLength(length: Int) -> String {
        var string = self
        let nsString = string as NSString
        if nsString.length >= length {
            string = nsString.substring(with:
                NSRange(
                    location: 0,
                    length: nsString.length > length ? length : nsString.length)
            )
        }
        return  string
    }
}
