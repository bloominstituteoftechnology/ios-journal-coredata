//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Joel Groomer on 10/2/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTimeStamp: UILabel!
    @IBOutlet weak var lblEntryBody: UILabel!
    
    var entry: JournalEntry? { didSet { updateViews() } }
    
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
        formatter.dateFormat = "mm/dd/yy, HH:mm a"
        lblTitle.text = entry.title
        lblEntryBody.text = entry.bodyText
        lblTimeStamp.text = formatter.string(from: entry.timestamp ?? Date())
    }
}
