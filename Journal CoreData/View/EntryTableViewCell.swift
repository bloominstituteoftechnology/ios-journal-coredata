//
//  EntryTableViewCell.swift
//  Journal CoreData
//
//  Created by Andrew Ruiz on 9/16/19.
//  Copyright © 2019 Andrew Ruiz. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    
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
        
        
        titleLabel.text = entry?.title
        bodyLabel.text = entry?.bodyText
        
        let dateFormatter = DateFormatter()
        guard let currentDate = entry?.timestamp else { return }
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        timeStampLabel.text = dateFormatter.string(from: currentDate)
    }

}
