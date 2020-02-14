//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Sal Amer on 2/12/20.
//  Copyright © 2020 Sal Amer. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    

    func updateViews() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        
        titleLabel.text = entry?.title
        descriptionLbl.text = entry?.bodytext
        dateTimeLbl.text = formatter.string(from: entry?.timestamp ?? Date())
    }
    
    
}
