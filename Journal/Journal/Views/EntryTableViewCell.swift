//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Eoin Lavery on 06/08/2020.
//  Copyright © 2020 Eoin Lavery. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    //MARK: - PROPERTIES
    static let reuseIdentifier = "EntryCell"
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - PRIVATE FUNCTIONS
    private func updateViews() {
        guard let entry = entry else { return }
        titleLabel.text = entry.title
        
        //Format Date as Long and then assign to label.text property
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        if let date = entry.timestamp {
            dateLabel.text = df.string(from: date)
        }
        
        descriptionLabel.text = entry.bodyText
    }
    
    /*override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    */
}
