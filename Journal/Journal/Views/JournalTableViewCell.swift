//
//  JournalTableViewCell.swift
//  Journal
//
//  Created by Eoin Lavery on 13/02/2020.
//  Copyright © 2020 Eoin Lavery. All rights reserved.
//

import UIKit

class JournalTableViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    //MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }

    //MARK: Private Functions
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateViews() {
        guard let entry = entry else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        
        titleLabel.text = entry.name
        notesLabel.text = entry.notes
        dateLabel.text = dateFormatter.string(from: entry.date ?? Date())
        
        
    }

}
