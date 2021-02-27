//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by James McDougall on 2/26/21.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var entryNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textViewLabel: UILabel!
    
    static let reuseIdentifier = "EntryCell"
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        entryNameLabel.text = entry.title
        dateLabel.text = String("\(entry.timeStamp)")
        textViewLabel.text = entry.bodyText
    }

}
