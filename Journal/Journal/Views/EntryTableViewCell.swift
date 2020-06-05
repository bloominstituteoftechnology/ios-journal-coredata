//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Bronson Mullens on 6/3/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var entryTextLabel: UILabel!
    
    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    static let reuseIdentifier = "EntryCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        entryTitle.text = entry.title
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        timestampLabel.text = dateFormatter.string(from: entry.timestamp ?? Date())
        entryTextLabel.text = entry.bodyText
    }
    
}
