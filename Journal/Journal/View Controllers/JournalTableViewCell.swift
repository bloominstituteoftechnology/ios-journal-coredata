//
//  JournalTableViewCell.swift
//  Journal
//
//  Created by Farhan on 9/17/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit

class JournalTableViewCell: UITableViewCell {
    
    var entry: Journal?{
        didSet{
            updateViews()
        }
    }
   
    func updateViews(){
        guard let entry = entry else {return}
        titleLabel.text = entry.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        timeLabel.text = dateFormatter.string(from: entry.timestamp!)
        
        subtitleLabel.text = entry.notes
        
    }

    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
}
