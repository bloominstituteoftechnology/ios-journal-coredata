//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Dahna on 5/18/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    // MARK: Properties
    static let reuseIdentifier = "EntryCell"
    
    var entry: Entry? {
        didSet {
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
    
    func updateViews() {
        guard let entry = entry else { return}
        guard let date = entry.timestamp else { return }
        titleLabel.text = entry.title
        dateLabel.text = date.stringDate()
        bodyTextLabel.text = entry.bodyText
    }

}

extension Date {
    func stringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/dd/yy, h:mm a"
        return dateFormatter.string(from: self)
    }
}
