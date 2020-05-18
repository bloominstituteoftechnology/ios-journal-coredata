//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Stephanie Ballard on 5/18/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Outlets -
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryTimestampLabel: UILabel!
    @IBOutlet weak var entryBodyTextView: UILabel!
    
    // MARK: - Properties -
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    static let reuseIdentifier = "EntryCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateViews() {
        
    }

}
