//
//  EntryTableViewCell.swift
//  CoreDataJournal
//
//  Created by Benjamin Hakes on 1/14/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    var entry: Entry?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews(){
        titleLabel.text = entry?.title
        subtitleLabel.text = entry?.bodyText
        idLabel.text = "\(entry?.timestamp)"
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
}
