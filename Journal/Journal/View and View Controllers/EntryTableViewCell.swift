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
        titleLabel.text = entry?.title
        
        //FIX: Make this prettier
        timeStampLabel.text = entry?.timeStamp?.description
        
        if let bodyText = entry?.bodyText {
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
