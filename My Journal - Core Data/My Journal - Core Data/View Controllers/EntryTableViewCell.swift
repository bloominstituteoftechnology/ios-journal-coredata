//
//  EntryTableViewCell.swift
//  My Journal - Core Data
//
//  Created by Nick Nguyen on 2/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell
{
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    lazy var dateFormatter: DateFormatter = {
        let dm = DateFormatter()
        dm.dateFormat = "MM-dd-yyyy HH:mm"
        dm.calendar = .current
        return dm
    }()
    
    // MARK: - Methods
    
    private func updateViews() {
        if let entry = entry {
            entryTitleLabel.text = entry.title
            entryBodyLabel.text = entry.bodyText
            timeStampLabel.text = dateFormatter.string(from: entry.timestamp ?? Date())
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var entryBodyLabel: UILabel!
    
    
}
