//
//  EntryTableViewCell.swift
//  journal-core-data-project
//
//  Created by Vuk Radosavljevic on 8/13/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    
    //MARK: - Methods
    func updateViews() {
        guard let entry = entry else {return}
        titleLabel.text = entry.title
        bodyLabel.text = entry.bodyText
        timestampLabel.text = entry.timestamp?.description
    }
}
