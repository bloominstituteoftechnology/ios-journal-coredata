//
//  EntryTableViewCell.swift
//  Journal CoreData
//
//  Created by Iyin Raphael on 9/24/18.
//  Copyright © 2018 Iyin Raphael. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    func updateView(){
        if let entry = entry {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            dateFormatter.dateStyle = .medium
            guard let date = entry.date else {return}
            dateLabel.text = dateFormatter.string(from:date)
            titleLabel.text = entry.title
            bodyTextLabel.text = entry.bodyText
        }
    
    }
    
    var entry: Entry?{
        didSet{
            updateView()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
}
