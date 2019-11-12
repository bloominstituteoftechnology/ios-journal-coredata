//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by brian vilchez on 9/16/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var entry: Entry? {
        didSet{
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let entry = entry else {return}
        TitleLabel.text = entry.title
        DescriptionLabel.text = entry.bodyText
        dateLabel.text = DateFormatter().string(from: entry.timeStamp ?? Date())
        
        
    }
    
}
