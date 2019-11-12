//
//  EntryTableViewCell.swift
//  Journal Core Data
//
//  Created by Niranjan Kumar on 11/11/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Methods
    
    func updateViews() {
        guard let entry = entry else { return }
        
        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "MM/dd/yyyy, h:mm a"
            return formatter
        }
        
        
        titleLabel.text = entry.title
        descriptionLabel.text = entry.bodyText
        timeStampLabel.text = dateFormatter.string(from: entry.timeStamp!)
        
    }
    
}
