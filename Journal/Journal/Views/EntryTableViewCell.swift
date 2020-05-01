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
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
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
        timeStampLabel.text = "\(dateFormatter.string(from: entry.timeStamp!))"
        bodyTextLabel.text = entry.bodyText
    }
}
