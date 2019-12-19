//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Chad Rutherford on 12/16/19.
//  Copyright © 2019 Chad Rutherford. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let bodyTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let outerView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 10
        return sv
    }()
    
    let innerView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        return sv
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        contentView.addSubview(outerView)
        innerView.addArrangedSubview(titleLabel)
        innerView.addArrangedSubview(dateLabel)
        outerView.addArrangedSubview(innerView)
        outerView.addArrangedSubview(bodyTextLabel)
        NSLayoutConstraint.activate([
            outerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            outerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            outerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            outerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    private func updateViews() {
        guard let entry = entry, let timestamp = entry.timestamp else { return }
        titleLabel.text = entry.title
        bodyTextLabel.text = entry.bodyText
        dateLabel.text = dateFormatter.string(from: timestamp)
    }
}
