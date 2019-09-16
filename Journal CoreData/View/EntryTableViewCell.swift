//
//  EntryTableViewCell.swift
//  Journal CoreData
//
//  Created by Andrew Ruiz on 9/16/19.
//  Copyright © 2019 Andrew Ruiz. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
