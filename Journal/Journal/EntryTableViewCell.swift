//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by ronald huston jr on 7/12/20.
//  Copyright © 2020 HenryQuante. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateViews() {
        guard let entry = entry else { return }
        
        titleLabel.text = entry.title
        detailLabel.text = entry.bodyText
        
    }

}
