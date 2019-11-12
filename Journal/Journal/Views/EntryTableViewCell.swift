//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-11.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            setUpSubViews()
            updateViews()
        }
    }
    
    // MARK: - UI Elements
    
    var titleLabel: UILabel!
    var timestampLabel: UILabel!
    var bodyLabel: UILabel!
    
    // MARK: - Methods
    
    func updateViews() {
        guard let entry = entry else {
            print("No entry from which to update for cell!")
            return
        }
        
        titleLabel.text = entry.title ?? ""
        timestampLabel.text = "\(entry.timestamp ?? Date())"
        bodyLabel.text = entry.bodyText ?? ""
    }
    
    func setUpSubViews() {
        titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleHorizontalResistance = titleLabel.contentHuggingPriority(for: .horizontal) - 1
        titleLabel.setContentHuggingPriority(titleHorizontalResistance, for: .horizontal)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        ])
        
        timestampLabel = UILabel()
        timestampLabel.textAlignment = .right
        addSubview(timestampLabel)
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let timestampLeadingAnchor = timestampLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 4)
        timestampLeadingAnchor.priority -= 1
        NSLayoutConstraint.activate([
            timestampLeadingAnchor,
            timestampLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            timestampLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
        ])
        
        bodyLabel = UILabel()
        bodyLabel.numberOfLines = 3
        addSubview(bodyLabel)
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            bodyLabel.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.topAnchor.constraint(greaterThanOrEqualTo: timestampLabel.bottomAnchor, constant: 8),
            bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 12),
            bodyLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
