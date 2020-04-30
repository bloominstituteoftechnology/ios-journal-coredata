//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Lambda_School_loaner_226 on 4/28/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var entryDate: UILabel!
    @IBOutlet weak var notesText: UILabel!
    
    var entry: Entry? {
        didSet {
            updateviews()
        }
    }
    
    func updateviews() {
        guard let entry = entry else { return }
        entryTitle.text = entry.title
        notesText.text = entry.bodyText
    }

}
