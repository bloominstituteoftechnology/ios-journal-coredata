//
//  EntryTableViewCell.swift
//  Journal (CoreData)
//
//  Created by Nathan Hedgeman on 7/22/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    //Properties
    var entry:Entry? {
        
        didSet {
            updateViews()
        }
    }

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //Functions
    
    func updateViews() {
        //Date needed to be unwrapped to silence errors
        guard let timestamp = entry?.timestamp else { return }
        
        nameLabel.text = entry?.title
        noteLabel.text = entry?.bodyText
        dateLabel.text = "\(timestamp)"
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
