//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Harmony Radley on 5/18/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

  
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        
    }

}
