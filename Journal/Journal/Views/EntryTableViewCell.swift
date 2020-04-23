//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Elizabeth Thomas on 4/22/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    
    
    // MARK: - IBActions
    @IBAction func createEntryButtonTapped(_ sender: Any) {
        
    }
    
    
    // MARK: - Methods
    func updateViews() {
        titleLabel.text = entry?.title
        timestampLabel.text = "\(entry?.timestamp)"
        entryLabel.text = entry?.bodyText
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
