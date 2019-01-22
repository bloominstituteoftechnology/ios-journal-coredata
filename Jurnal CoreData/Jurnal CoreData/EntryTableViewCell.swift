//
//  EntryTableViewCell.swift
//  Jurnal CoreData
//
//  Created by Sergey Osipyan on 1/21/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    
    func updateViews() {
        title.text = entry?.title
        timestamp.text = "\(String(describing: entry?.timestamp))"
        bodyText.text = entry?.bodyText
    }

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var bodyText: UILabel!
    

}
