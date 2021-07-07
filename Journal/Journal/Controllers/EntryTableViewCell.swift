//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Lambda_School_Loaner_268 on 2/24/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    
    // MARK: - Outlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var body: UILabel!
    
    
    // MARK: - Methods
    
    var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "M/d/yy h:mm a"
        return f
    }
    
   private func updateViews() {
        guard let entry = entry,
            let timeStamp = entry.timeStamp else { return }
        let timeString = dateFormatter.string(from: timeStamp)

        title.text = entry.title
        timeStampLabel.text = timeString
        body.text = entry.bodyText
    }
 

}
