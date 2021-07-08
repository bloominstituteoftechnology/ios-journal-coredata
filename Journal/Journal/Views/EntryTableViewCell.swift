//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Lambda_School_Loaner_204 on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy, h:mm a"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        return formatter
    }
    
    
    // MARK: - Functions
    
    private func updateViews() {
        guard let entry = entry else { return }
        
        titleLabel.text = entry.title
        timestampLabel.text = dateFormatter.string(from: entry.timestamp!)
        bodyLabel.text = entry.bodyText
    }

}
