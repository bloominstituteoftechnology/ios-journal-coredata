//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Nonye on 5/18/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    static let reuseIdentifier = "EntryCell"
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var journalTitleLabel: UILabel!
    @IBOutlet weak var journalEntryLabel: UILabel!
    @IBOutlet weak var journalEntryDate: UILabel!
    
    // MARK: - DATE FORMATTER
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy HH:mm"
        return formatter
    }()
    
    func string(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func updateViews() {
        guard let entry = entry else { return }
        
        journalTitleLabel.text = entry.title
        journalEntryDate.text = "\(entry.timeStamp!)"
        journalEntryLabel.text = entry.bodyText
        journalEntryDate.text = dateFormatter.string(from: entry.timeStamp!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
