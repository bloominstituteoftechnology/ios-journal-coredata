//
//  EntryTableViewCell.swift
//  Journal.CoreData
//
//  Created by beth on 2/24/20.
//  Copyright © 2020 elizabeth wingate. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var bodyTextField: UILabel!
    @IBOutlet weak var timestampTextField: UILabel!
    
    var entry: Entry? {
      didSet {
        updateViews()
    }
}
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/yy h:mm a"
        return formatter
    }

    private func updateViews() {
        guard let entry = entry,
        let timeStamp = entry.timeStamp else { return }
        let timeString = dateFormatter.string(from: timeStamp)
        titleTextField.text = entry.title
        bodyTextField.text = entry.bodyText
        timestampTextField.text = timeString
    }
}
