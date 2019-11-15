//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Thomas Sabino-Benowitz on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreData

class EntryTableViewCell: UITableViewCell {

//    MARK: +Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var bodyText: UILabel!
    
//    MARK: +Properties
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateViews() {
        titleLabel.text = entry?.title
        titleLabel.font = UIFont(name: "Futura", size: 30)
        
        timestamp.text = entry?.timestamp?.toString(dateFormat: "MM-dd-yyyy")
        bodyText.text = entry?.bodyText
    }

}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
