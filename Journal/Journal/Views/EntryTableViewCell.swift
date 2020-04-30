//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Waseem Idelbi on 4/22/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    //MARK: - Properties and IBOutlets -

    var dateFormatter = DateFormatter() {
        didSet {
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
        }
    }
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var bodyTextLabel: UILabel!
    

    //MARK: - Methods and IBActions -
    
    func updateViews() {
        guard let entry = entry else { return }
        titleLabel.text = entry.title
        timestampLabel.text = dateFormatter.string(from: entry.timestamp!)
        bodyTextLabel.text = entry.bodyText
    }
    
} //End of class
