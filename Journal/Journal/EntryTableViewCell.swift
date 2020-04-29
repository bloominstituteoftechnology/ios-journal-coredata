//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Jarren Campos on 4/22/20.
//  Copyright © 2020 Jarren Campos. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    var entry: Entry? {
        didSet{
            updateViews()
        }
    }
    
    @IBOutlet var entryTitleLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var entryDetailsLabel: UILabel!
    
    //MARK: - Outlets
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews(){
        guard let entry = entry else { return }
        
        entryTitleLabel.text = entry.title
//        timestampLabel.text = entry.timestamp
        entryDetailsLabel.text = entry.bodyText
    }

}
