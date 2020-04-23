//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Cameron Collins on 4/20/20.
//  Copyright © 2020 Cameron Collins. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    //Computed Property that holds all the cells information
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    static var identifier = "JournalCell"
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    //MARK: - Functions
    //Updates Views when entry is set
    func updateViews() {
        guard let entry = entry else { return }
        titleLabel.text = entry.title
        dateLabel.text = entry.timeStamp?.description
        textView.text = entry.bodyText
    }
}
