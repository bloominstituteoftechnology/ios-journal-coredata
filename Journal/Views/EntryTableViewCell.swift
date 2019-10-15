//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by macbook on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    // MARK: Properties
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
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM-dd-yyyy'T'HH:mm"
//        let newDate = dateFormatter.string(from: date)
//
        titleLabel.text = entry.title
        timestampLabel.text = TimestampFormatter.formatTimestamp(for: entry)
        bodyLabel.text = entry.bodyText
    }
}
