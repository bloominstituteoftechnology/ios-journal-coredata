//
//  EntryTableViewCell.swift
//  Journal.CoreData
//
//  Created by beth on 2/24/20.
//  Copyright © 2020 elizabeth wingate. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var bodyTextField: UILabel!
    @IBOutlet weak var timestampTextField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
