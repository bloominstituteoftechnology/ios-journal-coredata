//
//  EnteryTableViewCell.swift
//  Journal
//
//  Created by Christopher Aronson on 5/27/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit

class EnteryTableViewCell: UITableViewCell {
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timStampLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateViews() {

        guard let entry = entry else { return }

        titleLabel.text = entry.title
        bodyTextLabel.text = entry.bodyText

        let calendar = Calendar.current

        let month = calendar.component(.month, from: entry.timestamp ?? Date())
        let day = calendar.component(.day, from: entry.timestamp ?? Date())
        let year = calendar.component(.year, from: entry.timestamp ?? Date())
        let hour = calendar.component(.hour, from: entry.timestamp ?? Date())
        let minute = calendar.component(.minute, from: entry.timestamp ?? Date())

        timStampLabel.text = "\(month)/\(day)/\(year) \(hour):\(minute)"
    }

}
