//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Mark Poggi on 4/20/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "EntryCell"
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd/yy h:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var entryTextView: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let entry = entry else {return}
        titleLabel.text = entry.title
        entryTextView.text = entry.bodyText
        dateLabel.text = dateFormatter.string(from: entry.timestamp!)  // what is the right way to do this?  Why do I need to unwrap again?
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
