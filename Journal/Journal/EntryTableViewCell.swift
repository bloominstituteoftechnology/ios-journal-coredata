//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Jonathan Ferrer on 6/3/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {


    func updateViews() {
        guard let timeStamp = entry?.timeStamp else { return }
        titleLabel.text = entry?.title
        timestampLabel.text = "\(timeStamp)"
        bodyLabel.text = entry?.bodyText
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
}
