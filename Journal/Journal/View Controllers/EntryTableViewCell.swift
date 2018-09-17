//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Daniela Parra on 9/17/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func updateViews() {
        guard let entry = entry,
            let timestamp = entry.timestamp else { return }
        
        //Format date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MM/dd/yy h:mm a"
        let date = dateFormatter.string(from: timestamp)
        
        nameLabel.text = entry.title
        bodyLabel.text = entry.bodyText
        timestampLabel.text = date
        
    }
    
    var entry: Entry? {
        didSet{
            updateViews()
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
}
