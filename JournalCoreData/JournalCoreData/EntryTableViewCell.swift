//
//  EntryTableViewCell.swift
//  JournalCoreData
//
//  Created by Bhawnish Kumar on 4/20/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var entry: Entry?
    
    var dateFormatter: DateFormatter = {
          let newDate = DateFormatter()
          newDate.calendar = .current
          newDate.dateFormat = "MM-dd-yyyy h:mm a"
          return newDate
      }()

    
    private func updateViews() {
      
        guard let entry = entry else { return }
        
        entryTitleLabel.text = entry.title
        descriptionLabel.text = entry.bodyText
        timeLabel.text = dateFormatter.string(from: entry.timeStamp!)
        
    }
}
