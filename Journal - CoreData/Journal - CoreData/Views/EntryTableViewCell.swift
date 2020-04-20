//
//  EntryTableViewCell.swift
//  Journal - CoreData
//
//  Created by Nichole Davidson on 4/20/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "EntryCell"
    
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryTextLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
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
    
    func updateViews() {
        guard let entry = entry else { return }
        
        entryTitleLabel.text = entry.title
        entryTextLabel.text = entry.bodyText
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        let dateString = dateFormatter.string(from: today)
        timeStampLabel.text = dateString
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
