//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Scott Bennett on 9/24/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    var entry: Entry?{
        didSet {
            updateViews()
        }
    }
    
    
    func updateViews() {
        guard let title = entry?.title,
            let body = entry?.bodyText,
            let timestamp = entry?.timestamp else { return }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        titleLabel.text = title
        timestampLabel.text = dateFormatter.string(from: timestamp)
        bodyTextLabel.text = body
    }


}
