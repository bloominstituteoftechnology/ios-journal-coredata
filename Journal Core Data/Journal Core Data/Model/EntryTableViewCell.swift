//
//  EntryTableViewCell.swift
//  Journal Core Data
//
//  Created by Seschwan on 7/10/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLbl:     UILabel!
    @IBOutlet weak var bodyLbl:      UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    
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
        guard let entry     = entry else { return }
        titleLbl.text       = entry.title
        let formatter       = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        timeStampLbl.text   = formatter.string(from: entry.timestamp!)
        bodyLbl.text        = entry.bodyText
    }

}
