//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Paul Yi on 2/18/19.
//  Copyright © 2019 Paul Yi. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
