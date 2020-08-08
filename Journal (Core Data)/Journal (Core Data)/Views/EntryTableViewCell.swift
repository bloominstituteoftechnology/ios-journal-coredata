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


    private func updateViews() {
        guard let entry = entry else { return }

        entryTitleLabel.text = entry.title
        entryTextDetialLabel.text = entry.bodyText
        entryDateLabel.text = String("\(entry.timestamp)")

//        let dateFormatterGet = DateFormatter()
//        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatterGet.dateStyle = .short



//        let dateFormatterPrint = DateFormatter()
//        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
//
//        entryDateLabel == DateFormatter.date(<#T##self: DateFormatter##DateFormatter#>)

    }

}
