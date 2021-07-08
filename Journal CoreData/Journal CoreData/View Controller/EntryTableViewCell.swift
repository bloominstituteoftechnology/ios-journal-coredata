//
//  EntryTableViewCell.swift
//  Journal CoreData
//
//  Created by Ngozi Ojukwu on 8/20/18.
//  Copyright © 2018 iyin. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

 
    var entry: Entry?{
        didSet{
            updateViews()
        }
    }
    
    func updateViews(){
        guard let entry = entry else {return}
        
        nameLabel.text = entry.name
        noteLabel.text = entry.bodyText
      
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        guard let timestamp = entry.timestamp else { return }
        
        dateLabel.text = dateFormatter.string(from: timestamp)
    }

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
}
