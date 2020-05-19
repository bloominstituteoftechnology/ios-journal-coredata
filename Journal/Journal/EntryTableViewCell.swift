//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Harmony Radley on 5/18/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    // MARK: - Properties
    
  static let reuseIdentifer = "EntryCell"
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    // MARK: - IBOutlets
    
    
    
    // MARK: - Method
    private func updateViews() {
        guard let entry = entry else { return }
        
        // add IBOutlets here once created...
    }

}
