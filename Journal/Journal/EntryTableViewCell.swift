//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Mark Gerrior on 3/23/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    // MARK: - Properities
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
