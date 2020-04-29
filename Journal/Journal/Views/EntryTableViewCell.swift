//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Elizabeth Thomas on 4/22/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static var reuseIdentifier = "EntryCell"
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var date = Date()
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    
 
    // MARK: - Methods
    func updateViews() {
        guard let entry = entry else { return }
        
        titleLabel.text = entry.title
        entryLabel.text = entry.bodyText
        timestampLabel.text = date.getFormattedDate(format: "MM/dd/yy, HH:mm")
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
