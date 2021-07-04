//
//  EntryTableViewCell.swift
//  Journal (Core Data)
//
//  Created by Julian A. Fordyce on 2/18/19.
//  Copyright © 2019 Glas Labs. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
       
        guard let entry = entry,
            let timestamp = entry.timeStamp else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy h:mm a"
        let date = dateFormatter.string(from: timestamp)
        
        titleLabel.text = entry.title
        bodyTextLabel.text = entry.bodyText
        timestampLabel.text = date
        
    }
   


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    
}
