//
//  EntryTableViewCell.swift
//  Journal2
//
//  Created by Carolyn Lea on 8/20/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var entry: Entry?
    {
        didSet
        {
            updateViews()
        }
    }
    
    private func updateViews()
    {
        if let entry = entry
        {
            let currentDate = entry.timestamp
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy, h:mm a"
            let dateString = dateFormatter.string(from: currentDate!)
            
            titleLabel.text = entry.title
            timestampLabel.text = dateString
            bodyTextLabel.text = entry.bodyText
        }
    }
}
