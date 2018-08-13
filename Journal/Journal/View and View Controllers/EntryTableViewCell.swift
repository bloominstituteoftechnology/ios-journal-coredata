//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Andrew Liao on 8/13/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    func updateViews(){
        guard let entry = entry else {return}
        
        titleLabel.text = entry.title
        
        //FIX: Make this prettier
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        
        guard let date = entry.timeStamp else {return}
        
        timeStampLabel.text = dateFormatter.string(from: date)
        
        if let bodyText = entry.bodyText {
            bodyTextLabel.text = bodyText
        } else {
            bodyTextLabel.text = ""
        }
    }
    
    //MARK: - Properties
    var entry: Entry?{
        didSet{
            updateViews()
        }
    }
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
}
