//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Harmony Radley on 4/20/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let entry = entry else { return }
    }

}
