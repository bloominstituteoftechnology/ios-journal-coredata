//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Isaac Lyons on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var descriptionLabel: UILabel!
    
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
        guard let entry = entry,
            let date = entry.timestamp,
            let bodyText = entry.bodyText else { return }
        
        self.textLabel?.text = entry.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let dateText = dateFormatter.string(from: date)
        
        self.detailTextLabel?.text = "\(dateText). \(bodyText)"
    }

}
