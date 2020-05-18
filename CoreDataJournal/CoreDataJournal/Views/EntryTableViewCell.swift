//
//  EntryTableViewCell.swift
//  CoreDataJournal
//
//  Created by Marissa Gonzales on 5/18/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var entryDetailLabel: UILabel!
    func updateViews() {
        guard let entry = entry else { return }
          let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY, hh:mm"
        let rightNow = dateFormatter.string(from: entry.timestamp!)
        dateLabel.text = rightNow
        entryTitleLabel.text = entry.title
        entryDetailLabel.text = entry.bodyText
        
    }
}
