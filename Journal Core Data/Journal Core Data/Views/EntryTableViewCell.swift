//
//  EntryTableViewCell.swift
//  Journal Core Data
//
//  Created by Bhawnish Kumar on 3/23/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    
    var dateFormatter: DateFormatter = {
        let newDate = DateFormatter()
        newDate.calendar = .current
        newDate.dateFormat = "MM-dd-yyyy h:mm a"
        return newDate
    }()
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   

        // Configure the view for the selected state
    
    func updateViews() {
        guard let newEntry = entry else { return }
    
        titleLabel.text = newEntry.title
        bodyTextLabel.text = newEntry.bodyText
        timeStampLabel.text = dateFormatter.string(from: entry!.timeStamp!)
      
    }

}
