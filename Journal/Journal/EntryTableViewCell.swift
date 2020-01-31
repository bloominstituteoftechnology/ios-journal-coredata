//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Jorge Alvarez on 1/27/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
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
    
    private func updateViews() {
        guard let entry = entry else {return}
        
        titleLabel.text = entry.title
        // Date formatter property?
        timeLabel.text = "\(entry.timestamp ?? Date())"
        bodyLabel.text = entry.bodyText
    }

}
