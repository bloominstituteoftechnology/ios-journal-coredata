//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Rick Wolter on 11/11/19.
//  Copyright © 2019 Richar Wolter. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    
    
   
    
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryBodyLabel: UILabel!
    @IBOutlet weak var entryTimeStampLabel: UILabel!
    
    var entry: Entry? {
        didSet{
            updateViews()
        }
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateViews(){
        guard let entry = entry else {return}
        print("Heres the entry \(entry)")
        entryTitleLabel.text = entry.title
        entryBodyLabel.text = entry.bodyText
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        entryTimeStampLabel.text = dateFormatter.string(from: entry.timestamp!)
    }
    
    
    
    
    
}
