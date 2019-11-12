//
//  EntryTableViewCell.swift
//  Journal Core Data
//
//  Created by Niranjan Kumar on 11/11/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    // MARK: - Properties

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Methods

    func updateViews() {
        guard let title = titleLabel.text, !title.isEmpty else { return }
        
        guard let description = descriptionLabel.text, !description.isEmpty else { return }
        guard let timeStamp = timeStampLabel.text else { return }
        
        
    }
    
    
    

}
