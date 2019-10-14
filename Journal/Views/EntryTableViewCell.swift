//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by macbook on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    //MARK: Outlets
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
