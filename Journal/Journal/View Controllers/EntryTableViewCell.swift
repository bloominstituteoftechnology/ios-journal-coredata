//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Enayatullah Naseri on 7/10/19.
//  Copyright © 2019 Enayatullah Naseri. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateViews() {
        guard let entry = entry else {return}
        // time format
        let format = DateFormatter()
        format.dateStyle = .short
        format.timeStyle = .short
        
        titleLabel.text = entry.title
        dateLabel.text = format.string(from: entry.timestamp!)
        detailLabel.text = entry.bodyText
        
        
        
    }

}
