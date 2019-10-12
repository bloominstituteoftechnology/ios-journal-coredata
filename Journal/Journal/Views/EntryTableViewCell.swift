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
        
        DispatchQueue.main.async {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yy, hh:mm a"
            self.lblTitle.text = entry.title
            self.lblEntryBody.text = entry.bodyText
            self.lblTimeStamp.text = formatter.string(from: entry.timestamp ?? Date())
        }
    }
}
