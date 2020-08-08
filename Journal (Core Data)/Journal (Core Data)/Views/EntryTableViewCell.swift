//
//  EntryTableViewCell.swift
//  Journal (Core Data)
//
//  Created by Sammy Alvarado on 8/5/20.
//  Copyright © 2020 Sammy Alvarado. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryDateLabel: UILabel!
    @IBOutlet weak var entryTextDetialLabel: UILabel!

    static let resuseIdentifier = "JournalCell"

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    /*
     override func awakeFromNib() {
     super.awakeFromNib()
     // Initialization code
     }

     override func setSelected(_ selected: Bool, animated: Bool) {
     super.setSelected(selected, animated: animated)

     // Configure the view for the selected state
     }
     */


    // MARK: - IBAction

    lazy var dateFormatter: DateFormatter = {
        let dateformat = DateFormatter()
//        dateformat.dateStyle = .medium
//        dateformat.timeStyle = .short
        dateformat.dateFormat = "dd/MM/yyyy, HH:mm a"
        return dateformat
    }()



    private func updateViews() {
        guard let entry = entry else { return }

        entryTitleLabel.text = entry.title
        entryTextDetialLabel.text = entry.bodyText
        entryDateLabel.text = self.dateFormatter.string(from: entry.timestamp ?? Date())

    }

}
