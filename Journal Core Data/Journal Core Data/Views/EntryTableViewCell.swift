//
//  EntryTableViewCell.swift
//  Journal Core Data
//
//  Created by Bhawnish Kumar on 3/23/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    var entry: Entry?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateViews() {
        
        entry?.title =
    }

}
