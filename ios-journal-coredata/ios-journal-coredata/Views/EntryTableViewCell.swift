//
//  EntryTableViewCell.swift
//  ios-journal-coredata
//
//  Created by Conner on 8/13/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
  
  func updateViews() {
    if let entry = entry {
      entryTitleLabel.text = entry.title
      entryBodyLabel.text = entry.bodyText
      
      guard let timestamp = entry.timestamp else { return }
      df.dateFormat = "MM-dd-yyyy h:mm a"
      df.amSymbol = "AM"
      df.pmSymbol = "PM"
      entryTimeLabel.text = df.string(from: timestamp)
    }
  }
  
  // MARK: - Properties
  var entry: Entry? {
    didSet {
      updateViews()
    }
  }
  
  let df = DateFormatter()
  
  @IBOutlet var entryTitleLabel: UILabel!
  @IBOutlet var entryTimeLabel: UILabel!
  @IBOutlet var entryBodyLabel: UILabel!
  
}
