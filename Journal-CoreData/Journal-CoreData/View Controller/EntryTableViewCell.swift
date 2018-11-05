//
//  EntryTableViewCell.swift
//  Journal-CoreData
//
//  Created by Nikita Thomas on 11/5/18.
//  Copyright © 2018 Nikita Thomas. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let title = entry?.title, !title.isEmpty else {return}
        titleLabel.text = title
        bodyTextLabel.text = entry?.bodyText
        if let date = entry?.timeStamp {
            timeStampLabel.text = DateFormatter().string(from: date)
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
    
}
