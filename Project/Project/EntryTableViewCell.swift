//
//  EntryTableViewCell.swift
//  Project
//
//  Created by Ryan Murphy on 6/3/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    var entryController: EntryController?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    var entry: Entry? {
        
        didSet{
            updateViews()
        }
        
    }
    
    func updateViews() {
        
        guard let entry = entry else { return }
        
        titleLabel.text = entry.title
        previewLabel.text = entry.bodyText
        let dF = DateFormatter()
        dF.dateFormat = "MM-dd-yyyy"
        timestampLabel.text = dF.string(from: entry.timestamp ?? Date())
        
        
    }
    
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
}
