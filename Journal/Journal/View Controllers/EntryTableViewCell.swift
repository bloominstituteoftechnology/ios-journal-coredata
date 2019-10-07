//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Casualty on 10/2/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//


import UIKit

class EntryTableViewCell: UITableViewCell {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var dateStyleFormatter: DateFormatter = {
        let dateStyleFormatter = DateFormatter()
        dateStyleFormatter.dateStyle = .medium
        return dateStyleFormatter
    }()
    
    private var timeStyleFormatter: DateFormatter = {
        let timeStyleFormatter = DateFormatter()
        timeStyleFormatter.timeStyle = .short
        return timeStyleFormatter
    }()
    
    func updateViews() {
        self.titleLabel.text = entry?.title
        self.descriptionLabel.text = entry?.bodyText
        self.timestampLabel.text = self.dateString(for: entry)
    }

    func dateString(for entry: Entry?) -> String? {
        
        let dateString = "\(entry?.timestamp.map { dateStyleFormatter.string(from: $0) } ?? "")"
        let timeString = "\(entry?.timestamp.map { timeStyleFormatter.string(from: $0) } ?? "")"
        
        let combinedDateTimeString = "\(dateString) @ \(timeString)"
        return combinedDateTimeString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
