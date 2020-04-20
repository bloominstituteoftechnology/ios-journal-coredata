//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Chris Dobek on 4/20/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    static let reuseIdentifier = "EntryCell"
    
    @IBOutlet weak var titleLabel: UILabel!
       @IBOutlet weak var timestampLabel: UILabel!
       @IBOutlet weak var entryLabel: UILabel!

       var entry: Entry? {
           didSet {
               updateViews()
           }
       }
    
    private func updateViews() {
        guard let entry = entry else { return }

        titleLabel.text = entry.title
        // TODO: Format the date and put it into the timestamp label
        entryLabel.text = entry.bodyText
    }

}
