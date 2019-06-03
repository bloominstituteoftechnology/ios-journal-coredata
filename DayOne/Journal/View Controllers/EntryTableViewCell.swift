//
//  EntryTableViewCell.swift
//  Journal - Day One
//
//  Created by Sameera Roussi on 6/2/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    // MARK: - Update View
    private func updateView() {
        
    }
    
    // MARK: - Properties
    var entry: Entry? { didSet {updateView()} }
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
}
