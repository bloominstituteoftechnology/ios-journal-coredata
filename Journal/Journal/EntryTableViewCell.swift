//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Morgan Smith on 4/22/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var entryTitle: UILabel!
    
    @IBOutlet weak var entryDate: UILabel!
    
    @IBOutlet weak var entryDes: UILabel!
    
    var dateFormatter: DateFormatter {
              let formatter = DateFormatter()
              formatter.dateFormat = "MMM/dd/yy, HH:mm"
              formatter.timeZone = TimeZone(secondsFromGMT: 0)
              return formatter
          }
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        entryTitle.text = entry.title
        entryDate.text = dateFormatter.string(from: entry.timestamp!)
        entryDes.text = entry.bodyText
    
    }
    
    
}
