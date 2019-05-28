//
//  EntryTableViewCell.swift
//  JournalCoreDataHW
//
//  Created by Michael Flowers on 5/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    @IBOutlet weak var entryTitlelabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    
    private func updateViews(){
        guard let passedInEntry = entry else { return }
        entryTitlelabel.text = passedInEntry.title
        timestampLabel.text = passedInEntry.timestamp?.description
        bodyLabel.text = passedInEntry.bodyText
    }

}
