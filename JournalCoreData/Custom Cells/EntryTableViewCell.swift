//
//  EntryTableViewCell.swift
//  JournalCoreData
//
//  Created by Gi Pyo Kim on 10/14/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
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
        guard let entry = entry else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy h:mm a"
        
        titleLabel.text = entry.title
        bodyLabel.text = entry.bodyText
        timeLabel.text = formatter.string(from: entry.timestamp!)
    }
    
    

}
