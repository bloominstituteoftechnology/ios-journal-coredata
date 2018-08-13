//
//  EntryTableViewCell.swift
//  ios-journal-coredata
//
//  Created by De MicheliStefano on 13.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    
    private func updateViews() {
        
    }
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
}
