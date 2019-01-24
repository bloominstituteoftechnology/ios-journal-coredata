//
//  EntryTableViewCell.swift
//  Jurnal CoreData
//
//  Created by Sergey Osipyan on 1/21/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
   
    func updateViews() {
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let timeAndDate = dateFormatter.string(from: date)
        
        guard let entry = entry else { return }
        title.text = entry.title
        timestamp.text = timeAndDate
        bodyText.text = entry.bodyText
    }

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var bodyText: UILabel!
    

}
