//
//  EntryTableViewCell.swift
//  iosJournalProject
//
//  Created by BrysonSaclausa on 8/5/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit
import CoreData

class EntryTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let reuseIdentifier = "EntryCell"
    private let formatter = DateFormatter()
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    // MARK: - IBOutlets
       @IBOutlet weak var titleLabel: UILabel!
       @IBOutlet weak var timestampLabel: UILabel!
       @IBOutlet weak var bodyTextView: UILabel!
    
    private func updateViews() {
        //Create an `updateViews()` function that takes the values from the `entry` variable and places them in the outlets.
        guard let entry = entry else { return }
        titleLabel.text = entry.title
        bodyTextView.text = entry.bodyText
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        if let timestamp = entry.timestamp {
            timestampLabel.text = formatter.string(from: timestamp)
        }

    }

}

