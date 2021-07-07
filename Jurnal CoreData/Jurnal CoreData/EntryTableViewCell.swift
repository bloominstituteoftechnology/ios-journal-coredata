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
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .full
//        dateFormatter.timeStyle = .full
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm"
        return  dateFormatter.string(from: date!)
        
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        guard let date = entry.timestamp else { return }
        title.text = entry.title
        timestamp.text = convertDateFormater("\(date)")
        bodyText.text = entry.bodyText
    }

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var bodyText: UILabel!
    

}
