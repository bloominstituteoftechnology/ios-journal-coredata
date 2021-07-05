//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Joshua Rutkowski on 2/12/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Functions
    
    func updateViews() {
        let formatter = DateFormatter()
         formatter.dateFormat = "MM/dd/yy"

         titleLabel.text = entry?.title
         bodyLabel.text = entry?.bodyText
         timestampLabel.text = formatter.string(from: entry?.timestamp ?? Date())
    }


}
