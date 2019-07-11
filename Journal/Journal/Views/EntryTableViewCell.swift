//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Michael Stoffer on 7/10/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets and Properties
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var bodyTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
