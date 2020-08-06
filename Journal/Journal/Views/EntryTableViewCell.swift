//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Cora Jacobson on 8/5/20.
//  Copyright © 2020 Cora Jacobson. All rights reserved.
//

import UIKit
import CoreData

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "EntryCell"
    private let formatter = DateFormatter()
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    
    // MARK: - Private Functions
    
    private func updateViews() {
        guard let entry = entry else { return }
        titleLabel.text = entry.title
        bodyTextLabel.text = entry.bodyText
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        if let timestamp = entry.timestamp {
            timestampLabel.text = formatter.string(from: timestamp)
        }
    }

}
