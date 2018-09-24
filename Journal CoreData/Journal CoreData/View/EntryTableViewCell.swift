//
//  EntryTableViewCell.swift
//  Journal CoreData
//
//  Created by Ilgar Ilyasov on 9/24/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet { updateViews() }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    // MARK: Update views
    
    func updateViews() {
        guard let title = entry?.title,
            let bodyText = entry?.bodyText,
            let timestamp = entry?.timestamp else { return }
        
        // Format Date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        titleLabel.text = title
        bodyLabel.text = bodyText
        timestampLabel.text = formatter.string(from: timestamp)
    }
}
