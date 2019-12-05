//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by denis cedeno on 12/4/19.
//  Copyright © 2019 DenCedeno Co. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var bodyText: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
