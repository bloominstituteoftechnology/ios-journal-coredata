//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Brian Rouse on 5/18/20.
//  Copyright © 2020 Brian Rouse. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    // MARK: - iVars
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - CellLifeCycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Helper Methods
    
    func updateViews() {
        guard let entry = entry else { return }

        titleLbl.text = entry.title
        descriptionLbl.text = entry.bodyText

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy, h:mm a"
        let timestampFormatted = dateFormatter.string(from: (entry.timestamp)!)

        dateLbl.text = timestampFormatted
    }

}
