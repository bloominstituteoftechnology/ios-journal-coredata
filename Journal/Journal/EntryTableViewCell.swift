//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Blake Andrew Price on 12/5/19.
//  Copyright © 2019 Blake Andrew Price. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var previewLabel: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
