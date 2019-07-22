//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Sean Acres on 7/22/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var entryBodyText: UILabel!
    @IBOutlet weak var entryTimestamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
