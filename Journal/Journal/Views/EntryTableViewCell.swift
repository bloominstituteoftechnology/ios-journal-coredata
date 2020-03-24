//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Wyatt Harrell on 3/23/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    static let numberFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateStyle = .short
      dateFormatter.timeStyle = .short
      return dateFormatter
    }()

    func updateViews() {
        guard let entry = entry else { return }
        titleLabel.text = entry.title
        descriptionLabel.text = entry.bodyText
        let date = EntryTableViewCell.numberFormatter.string(from: entry.timestamp!)
        timeStampLabel.text = "\(date)"
    }
    
}
