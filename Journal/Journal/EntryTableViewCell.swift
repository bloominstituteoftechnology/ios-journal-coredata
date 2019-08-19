//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Bradley Yin on 8/19/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
