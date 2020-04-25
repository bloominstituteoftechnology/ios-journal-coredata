//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Claudia Contreras on 4/22/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateAndTimeLabel: UILabel!
    @IBOutlet var excerptLabel: UILabel!
    
    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        
    }

}
