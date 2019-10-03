//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Fabiola S on 10/2/19.
//  Copyright © 2019 Fabiola Saga. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryBodyLabel: UILabel!
    @IBOutlet weak var entryTimeLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var formattedDate: String {
        guard let entry = entry else {
            <#statements#>
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
        
        entryTitleLabel.text = entry.title
        entryBodyLabel.text = entry.bodyText
        entryTimeLabel.text = String(entry.timeStamp ?? "N/A")
    }
    
    

}
