//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Daniela Parra on 9/17/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    private func updateViews() {
        guard let entry = entry else { return }
        
        nameLabel.text = entry.title
        bodyLabel.text = entry.bodyText
        timestampLabel.text = entry.timestampString
        
    }
    
    var entry: Entry? {
        didSet{
            updateViews()
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
}
