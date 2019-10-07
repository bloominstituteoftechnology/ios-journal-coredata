//
//  EntryTableViewCell.swift
//  MyJournal
//
//  Created by Eoin Lavery on 02/10/2019.
//  Copyright © 2019 Eoin Lavery. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    //MARK: - IBOUTLETS
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryTimestampLabel: UILabel!
    @IBOutlet weak var entryNotesLabel: UILabel!

    //MARK: - PROPERTIES
    var entryController: EntriesController?
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - PRIVATE FUNCTIONS
    func updateViews() {
        guard let entry = entry else { return }
        if let name = entry.name, let bodyText = entry.bodyText, let timestamp = entry.timestamp {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            
            let timestampString = dateFormatter.string(from: timestamp)
            
            entryTitleLabel.text = name.capitalized
            entryNotesLabel.text = bodyText
            entryTimestampLabel.text = timestampString
        }
    }
    
}
