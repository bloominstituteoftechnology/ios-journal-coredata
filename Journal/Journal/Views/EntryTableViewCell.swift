//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Lambda_School_Loaner_259 on 3/23/20.
//  Copyright © 2020 DeVitoC. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryBodyLabel: UILabel!
    @IBOutlet weak var entryDateLabel: UILabel!
    
    
    // MARK: - View Lifecycle
    
    
    func updateViews() {
        guard let entry = entry else { return }
        entryTitleLabel.text = entry.title
        entryBodyLabel.text = entry.bodyText
        guard let timestamp = entry.timestamp else { return }
        entryDateLabel.text = "\(timestamp)"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
