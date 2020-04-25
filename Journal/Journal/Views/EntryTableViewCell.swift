//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Breena Greek on 4/22/20.
//  Copyright © 2020 Breena Greek. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "EntryCell"
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func updateViews() {
        guard let entry = entry else { return }
        titleLabel.text = entry.title
        timeStampLabel.text = "\(entry.timeStamp ?? Date())"
        bodyTextLabel.text = entry.bodyText
    }
}
