//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Zack Larsen on 12/16/19.
//  Copyright © 2019 Zack Larsen. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var bodyText: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var entry: Entry?
    
    private func updateViews() {
        title.text = entry?.title ?? "Create Task"
        bodyText.text = entry?.bodyText
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
