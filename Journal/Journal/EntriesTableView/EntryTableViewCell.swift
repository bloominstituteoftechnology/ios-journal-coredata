//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Shawn Gee on 3/23/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var entry: Entry? { didSet { updateViews() }}
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    
    // MARK: - Private
    
    func updateViews() {
        guard let entry = entry else { return }
        titleLabel.text = entry.title
        bodyLabel.text = entry.bodyText
        timestampLabel.text = entry.timestamp.shortString
    }
}
